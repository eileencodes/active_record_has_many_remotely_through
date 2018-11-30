require "active_record_has_many_remotely_through/version"
require "active_record"
require "active_record/associations_has_many_remotely_through_extension"

module ActiveRecordHasManyRemotelyThrough
  class Error < StandardError; end
end

ActiveRecord::Base.include ActiveRecord::AssociationsHasManyRemotelyThroughExtension
