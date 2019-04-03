require "active_record_has_many_split_through/version"
require "active_record"
require "active_record/associations_has_many_split_through_extension"

module ActiveRecordHasManySplitThrough
  class Error < StandardError; end
end

ActiveRecord::Base.include ActiveRecord::AssociationsHasManySplitThroughExtension
