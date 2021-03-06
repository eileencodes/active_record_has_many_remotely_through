# frozen_string_literal: true

A.connection.create_table :shipping_companies, force: true do |t|
  t.string :name
end

A.connection.create_table :offices, force: true do |t|
  t.string :name
  t.references :shipping_company
end

A.connection.create_table :employees, force: true do |t|
  t.string :name
  t.references :office
end

A.connection.create_table :whistles, force: true do |t|
  t.references :ship
end

B.connection.create_table :docks, force: true do |t|
  t.string :name
  t.references :shipping_company
end

B.connection.create_table :favorites, force: true do |t|
  t.integer :favoritable_id
  t.integer :employee_id
  t.string  :favoritable_type
end

C.connection.create_table :ships, force: true do |t|
  t.string :name
  t.references :dock
end

D.connection.create_table :containers, id: false, force: true do |t|
  t.primary_key :registration_number
  t.references :dock
end
