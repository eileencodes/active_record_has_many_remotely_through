# frozen_string_literal: true

module ActiveRecord
  module Associations
    class SplitAssociationScope < AssociationScope
      def scope(association)
        # source of the through reflection
        reflection = association.reflection
        #remove all previously set scope of passed in association
        scope = association.klass.unscoped

        chain = get_chain(reflection, association, scope.alias_tracker)

        reverse_chain = chain.reverse
        first_reflection = reverse_chain.shift
        first_join_ids = [association.owner.id]
        initial_values = [first_reflection, first_join_ids]

        last_reflection, join_ids = reverse_chain.inject(initial_values) do |(reflection, join_ids), next_reflection|
          key = reflection.join_keys.key
          records = reflection.klass.where(key => join_ids)

          # Preventing the reflection from being loaded on the
          # last reflection in the chain, that way anything the user
          # wants to apply to the reflection will still work.
          foreign_key = next_reflection.join_keys.foreign_key
          [next_reflection, records.pluck(foreign_key)]
        end

        key = last_reflection.join_keys.key
        last_reflection.klass.where(key => join_ids)
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
