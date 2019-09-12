# frozen_string_literal: true

module ActiveRecord
  module Associations
    class SplitAssociationScope < AssociationScope
      def scope(association)
        # source of the through reflection
        source_reflection = association.reflection
        options = source_reflection.options

        # remove all previously set scopes of passed in association
        scope = association.klass.unscoped

        chain = get_chain(source_reflection, association, scope.alias_tracker)

        reverse_chain = chain.reverse
        first_reflection = reverse_chain.shift
        first_join_ids = [association.owner.id]

        initial_values = [first_reflection, first_join_ids]

        last_reflection, last_join_ids = reverse_chain.inject(initial_values) do |(reflection, join_ids), next_reflection|
          key = reflection.join_keys.key

          # "WHERE key IN ()" is invalid SQL and will happen if join_ids is empty,
          # so we gotta catch it here in ruby
          record_ids = if join_ids.present?

            where_sql = ActiveRecord::Base.sanitize_sql(["#{key} IN (?)", join_ids])
            records = reflection.klass.where(where_sql)

            if options[:source_type]
              table = reflection.aliased_table
              type = "#{options[:source]}_type"
              polymorphic_type = transform_value(options[:source_type])

              records = apply_scope(records, table, type, polymorphic_type)
            end

            foreign_key = next_reflection.join_keys.foreign_key
            records.pluck(foreign_key)
          else
            []
          end

          [next_reflection, record_ids]
        end

        if last_join_ids.present?
          key = last_reflection.join_keys.key
          where_sql = ActiveRecord::Base.sanitize_sql(["#{key} IN (?)", last_join_ids])
          last_reflection.klass.where(where_sql)
        else
          last_reflection.klass.none
        end
      end

      def apply_scope(scope, table, key, value)
        if scope.table == table
          scope.where!(key => value)
        else
          scope.where!(table.name => { key => value })
        end
      end
    end

    # = Active Record Has Many Through Association
    class HasManySplitThroughAssociation < HasManyThroughAssociation #:nodoc:
      def scope
        SplitAssociationScope.create.scope(self)
      end

      def find_target
        scope
      end
    end
  end
end
