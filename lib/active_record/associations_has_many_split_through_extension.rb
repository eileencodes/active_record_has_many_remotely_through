module ActiveRecord
  module Reflection
    class SplitThroughReflection < ThroughReflection
      def association_class
        ActiveRecord::Associations::HasManySplitThroughAssociation
      end
    end
  end

  module Associations
    module Builder
      autoload :HasManySplitThrough, "active_record/associations/builder/has_many_split_through"
    end

    autoload :HasManySplitThroughAssociation, "active_record/associations/has_many_split_through_association"
  end

  module AssociationsHasManySplitThroughExtension
    extend ActiveSupport::Concern

    module ClassMethods
      def has_many(name, scope = nil, **options, &extension)
        if options.key?(:split) && options[:split]
          reflection = ActiveRecord::Associations::Builder::HasManySplitThrough.build(self, name, scope, options, &extension)
          reflection = ActiveRecord::Reflection::SplitThroughReflection.new(reflection.send(:delegate_reflection))
          Reflection.add_reflection self, name, reflection
        else
          options.delete :split
          super
        end
      end
    end
  end
end
