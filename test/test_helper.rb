$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "active_record_has_many_remotely_through"
require "byebug"

require "minitest/autorun"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Schema.verbose = false

class ShippingCompany < ActiveRecord::Base
  has_many :offices
  has_many :employees, through: :offices

  # in other databases
  has_many :docks
  has_many :ships, remotely_through: :docks
end

class Office < ActiveRecord::Base
  belongs_to :shipping_company
  has_many :employees
end

class Employee < ActiveRecord::Base
  belongs_to :office
end

class Dock < ActiveRecord::Base
  # connect to a different database
  establish_connection(adapter: 'sqlite3', database: ':memory:')

  belongs_to :shipping_company
  has_many :ships
end

class Ship < ActiveRecord::Base
  # connect to a different database
  establish_connection(adapter: 'sqlite3', database: ':memory:')

  belongs_to :dock
end

require_relative "schema"
