$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "active_record_has_many_split_through"
require "minitest/autorun"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Schema.verbose = false

NO_SPLIT = ENV['NO_SPLIT']

class A < ActiveRecord::Base
  self.abstract_class = true
end

class B < ActiveRecord:: Base
  self.abstract_class = true

  unless NO_SPLIT
    establish_connection(adapter: 'sqlite3', database: ':memory:')
  end
end

class C < ActiveRecord:: Base
  self.abstract_class = true

  unless NO_SPLIT
    establish_connection(adapter: 'sqlite3', database: ':memory:')
  end
end

class D < ActiveRecord:: Base
  self.abstract_class = true

  unless NO_SPLIT
    establish_connection(adapter: 'sqlite3', database: ':memory:')
  end
end

class ShippingCompany < A
  has_many :offices # A
  has_many :employees, through: :offices # A → A

  has_many :docks # B
  has_many :ships, through: :docks, split: !NO_SPLIT  # B → C
  has_many :whistles, through: :ships, split: !NO_SPLIT  # C → A
  has_many :containers, through: :docks, split: !NO_SPLIT  # B → D

  has_many :broken_whistles,
     -> { where(broken: true).order(id: :desc) },
     through: :ships,
     source: :whistles,
     split: !NO_SPLIT # C → A
end

class Office < A
  belongs_to :shipping_company # A
  has_many :employees # A
end

class Employee < A
  belongs_to :office # A
  has_many :favorites

  has_many :favorite_ships,
    through: :favorites,
    source: :favoritable,
    source_type: "Ship",
    split: !NO_SPLIT
end

class Whistle < A
  belongs_to :ship # C
end

class Dock < B
  belongs_to :shipping_company # A
  has_many :ships # C
  has_many :containers # D
  has_many :favorites, as: :favoritable #B
end

class Favorite < B
  belongs_to :employee
  belongs_to :favoritable, polymorphic: true
end

class Ship < C
  belongs_to :dock # B
  has_many :whistles # A
  has_many :favorites, as: :favoritable #B
  has_many :containers,
    foreign_key: "container_registration_number_id",
    through: :dock,
    split: !NO_SPLIT # B → D
end

class Container < D
  self.primary_key = "registration_number"
  belongs_to :dock # B
end

require_relative "schema"
