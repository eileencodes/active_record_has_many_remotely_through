# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :shipping_companies, force: true do |t|
    t.string :name
  end

  create_table :offices, force: true do |t|
    t.string :name
    t.references :shipping_company
  end

  create_table :employees, force: true do |t|
    t.string :name
    t.references :office
  end
end

# in other databases

Dock.connection.create_table :docks, force: true do |t|
  t.string :name
  t.references :shipping_company
end

Ship.connection.create_table :ships, force: true do |t|
  t.string :name
  t.references :dock
end
