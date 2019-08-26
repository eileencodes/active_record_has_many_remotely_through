# frozen_string_literal: true

module ActiveRecord
  module Associations
    class SplitAssociationScope < AssociationScope
      def scope(association)
        reflection = association.reflection
        scope = association.klass.unscoped

        chain = get_chain(reflection, association, scope.alias_tracker)

        reverse_chain = chain.reverse
        first_refl = reverse_chain.shift
        first_join_ids = [association.owner.id]

        last_refl, last_join_ids = reverse_chain.inject([first_refl, first_join_ids]) do |(prev_refl, prev_join_ids), next_refl|
          records = prev_refl.klass.unscoped.where(prev_refl.join_keys.key => prev_join_ids)
          # Preventing the reflection from being loaded on the
          # last reflection in the chain, that way anything the user
          # wants to apply to the reflection will still work.
          [next_refl, records.pluck(next_refl.join_keys.foreign_key)]
        end

        last_refl.klass.unscoped.where(last_refl.join_keys.key => last_join_ids)
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
