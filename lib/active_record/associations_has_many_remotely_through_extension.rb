module ActiveRecord
  module Associations
    module Builder
      autoload :HasManyRemotelyThrough, "active_record/associations/builder/has_many_remotely_through"
    end

    autoload :HasManyRemotelyThroughAssociation, "active_record/associations/has_many_remotely_through_association"
  end

  module AssociationsHasManyRemotelyThroughExtension
    extend ActiveSupport::Concern

    module ClassMethods
      def has_many(name, scope = nil, **options, &extension)
        if options.key?(:remotely_through)
          reflection = ActiveRecord::Associations::Builder::HasManyRemotelyThrough.build(self, name, scope, options, &extension)
          Reflection.add_reflection self, name, reflection
        else
          super
        end
      end
    end
  end
end
