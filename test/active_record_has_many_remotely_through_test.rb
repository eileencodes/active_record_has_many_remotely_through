require "test_helper"

class ActiveRecordHasManyRemotelyThroughTest < Minitest::Test
  def setup
    create_fixtures
  end

  def teardown
    remove_everything
  end

  def test_that_it_has_a_version_number
    refute_nil ::ActiveRecordHasManyRemotelyThrough::VERSION
  end

  def test_can_create_records
    assert_equal 1, ShippingCompany.count
    assert_equal 1, Office.count
    assert_equal 1, Employee.count
    assert_equal 1, Dock.count
    assert_equal 1, Ship.count
  end

  def test_counting_through_same_database
    assert_equal 1, @company.employees.count
  end

  def test_counting_through_remote_database
    skip "for now"
    assert_equal 1, @company.ships.count
  end

  def test_fetching_through_same_database
    assert_equal @employee.id, @company.employees.first.id
  end

  def test_fetching_through_remote_database
    skip "for now"
    assert_equal @ship.id, @company.ships.first.id
  end

  def test_appending_through_same_database
    skip "for now"
    @company.employees << Employee.new(name: "Howard")
    assert_equal 2, @company.employees.reload.size
  end

  def test_appending_through_remote_database
    skip "for now"
  end

  private

  def create_fixtures
    @company = ShippingCompany.create!(name: "🛳")

    @office = @company.offices.create!(name: "Back Office")
    @employee = @office.employees.create!(name: "Alice")

    @dock = @company.docks.create!(name: "Primary")
    @ship = @dock.ships.create!(name: "Alton")
  end

  def remove_everything
    ShippingCompany.connection.execute("delete from shipping_companies;")
    Office.connection.execute("delete from offices;")
    Employee.connection.execute("delete from employees;")
    Dock.connection.execute("delete from docks;")
    Ship.connection.execute("delete from ships;")
  end
end
