# frozen_string_literal: true

module ActiveRecord
  module Associations
    class RemoteAssociationScope < AssociationScope
      def scope(association)
        reflection = association.reflection
        scope = association.klass.unscoped

        chain = get_chain(reflection, association, scope.alias_tracker)

        join_ids = [association.owner.id]
        records = nil

        chain.reverse.each do |refl|
          records = refl.klass.unscoped.where(refl.join_keys.key => join_ids)
          join_ids = records.map(&:id)
        end

        records
      end
    end
    # = Active Record Has Many Through Association
    class HasManyRemotelyThroughAssociation < HasManyThroughAssociation #:nodoc:
      def find_target
        RemoteAssociationScope.create.scope(self)
      end
    end
  end
end
