# frozen_string_literal: true

module ActiveRecord::Associations::Builder # :nodoc:
  class HasManyRemotelyThrough < HasMany #:nodoc:
    def self.valid_options(options)
      super + [:split]
    end
  end
end
