# frozen_string_literal: true

module ActiveRecord
  module Associations
    class SplitAssociationScope < AssociationScope
      def scope(association)
        reflection = association.reflection
        scope = association.klass.unscoped

        chain = get_chain(reflection, association, scope.alias_tracker)

        join_ids = [association.owner.id]
        records = nil

        reverse_chain = chain.reverse
        last_reflection = reverse_chain.last
        reverse_chain.each do |refl|
          records = refl.klass.unscoped.where(refl.join_keys.key => join_ids)
          # Preventing the reflection from being loaded on the
          # last reflection in the chain, that way anything the user
          # wants to apply to the reflection will still work.
          if refl != last_reflection
            records = records.select(:id)
            join_ids = records.map(&:id)
          end
        end

        records
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
