# frozen_string_literal: true

module ActiveRecord
  module Associations
    class SplitAssociationScope < AssociationScope
      def scope(association)
        reflection = association.reflection
        scope = association.klass.unscoped

        chain = get_chain(reflection, association, scope.alias_tracker)

        join_ids = [association.owner.id]

        m = chain.reverse.inject do |acc, refl|
          records = acc.klass.unscoped.where(acc.join_keys.key => join_ids)
          # Preventing the reflection from being loaded on the
          # last reflection in the chain, that way anything the user
          # wants to apply to the reflection will still work.
          join_ids = records.pluck(refl.join_keys.foreign_key)

          refl
        end

        m.klass.unscoped.where(m.join_keys.key => join_ids)
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
