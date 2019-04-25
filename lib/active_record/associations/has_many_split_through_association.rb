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

        chain.reverse.each do |refl|
          records = refl.klass.unscoped.where(refl.join_keys.key => join_ids)
          join_ids = records.map(&:id)
        end

        records
      end
    end

    class ScopeProxy
      def initialize(association, target_scope, association_scope)
        @association = association
        @target_scope = target_scope
        @association_scope = association_scope
        @select_values = nil
      end

      def eager_load_values
        []
      end

      def includes_values
        []
      end

      def spawn
        self
      end

      def skip_query_cache_value
        false
      end

      def pluck(*column_names)
        SplitAssociationScope.create.scope(@association).pluck(*column_names)
      end

      attr_accessor :select_values
    end

    class CollectionProxyDelegate < DelegateClass(ActiveRecord::Associations::CollectionProxy)
      def count
        raise NotImplementedError
      end

      def pluck(*args)
        raise NotImplementedError
      end
    end

    # = Active Record Has Many Through Association
    class HasManySplitThroughAssociation < HasManyThroughAssociation #:nodoc:
      def reader
        @proxy = Class.new(CollectionProxy.send(:relation_class_for, klass)) {
          def pluck(*args)
            SplitAssociationScope.create.scope(@association).pluck(*args)
          end

          def count
            SplitAssociationScope.create.scope(@association).count
          end

          def first
            SplitAssociationScope.create.scope(@association).first
          end

          def build(attributes = {}, &block)
            m = method(__method__)
            while m
              p m.source_location
              m = m.super_method
            end
            super
          end
        }.new(klass, self)
        super
      end

      def find_target
        SplitAssociationScope.create.scope(self)
      end
    end
  end
end