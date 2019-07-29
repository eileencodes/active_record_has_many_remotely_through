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

C.connection.create_table :ships, force: true do |t|
  t.string :name
  t.references :dock
end

C.connection.create_table :chairs, force: true do |t|
  t.references :ship
end

D.connection.create_table :port_holes, force: true do |t|
  t.references :ship
end

D.connection.create_table :chair_legs, force: true do |t|
  t.references :chair
end
