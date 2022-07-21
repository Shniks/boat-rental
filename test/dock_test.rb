require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/dock'

class DockTest < Minitest::Test

  def test_if_it_exists
    dock = Dock.new("The Rowing Dock", 3)

    assert_instance_of Dock, dock
  end

  def test_it_has_attributes
    dock = Dock.new("The Rowing Dock", 3)

    assert_equal "The Rowing Dock", dock.name
    assert_equal 3, dock.max_rental_time
  end

  def test_it_can_rent_boats_and_populate_rental_log
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)

    expectation = ({
                    kayak_1 => patrick,
                    kayak_2 => patrick,
                    sup_1 => eugene
                  })

    assert_equal expectation, dock.rental_log
  end

  def test_it_can_charge_renters_for_renting_boats
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)
    kayak_1.add_hour
    kayak_1.add_hour
    expectation_1 = ({
                      :card_number => "4242424242424242",
                      :amount => 40
                      })

    assert_equal expectation_1, dock.charge(kayak_1)
  end

  def test_it_charges_renters_only_for_maximum_rental_time
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour # Any hours past the max rental time should not count
    sup_1.add_hour

    expectation_1 = ({
      :card_number => "1313131313131313",
      :amount => 45
      })

    assert_equal expectation_1, dock.charge(sup_1)
  end

  def test_boats_can_be_returned_with_revenue_earned
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    patrick = Renter.new("Patrick Star", "4242424242424242")

    dock.rent(kayak_1, patrick) # Rent Boats out to first Renter
    dock.rent(kayak_2, patrick)
    dock.log_hour # kayak_1 and kayak_2 are rented an additional hour
    dock.rent(canoe, patrick)
    dock.log_hour # kayak_1, kayak_2, and canoe are rented an additional hour

    expectation_1 = ({
      :card_number => "4242424242424242",
      :amount => 40
      })
    expectation_2 = ({
      :card_number => "4242424242424242",
      :amount => 25
      })
    expectation_3 = ({
      :card_number => "4242424242424242",
      :amount => 40
      })

    assert_equal expectation_1, dock.charge(kayak_1)
    assert_equal expectation_2, dock.charge(canoe)
    assert_equal expectation_3, dock.charge(kayak_2)
    assert_equal 0, dock.revenue # Revenue should not be generated until boats are returned

    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)

    assert_equal 105, dock.revenue
  end

  def test_boats_can_be_returned_with_revenue_earned
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    sup_2 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1, patrick) # Rent Boats out to first Renter
    dock.rent(kayak_2, patrick)
    dock.log_hour # kayak_1 and kayak_2 are rented an additional hour
    dock.rent(canoe, patrick)
    dock.log_hour # kayak_1, kayak_2, and canoe are rented an additional hour

    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)

    dock.rent(sup_1, eugene) # Rent Boats out to a second Renter
    dock.rent(sup_2, eugene)
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.log_hour # Any hours rented past the max rental time don't factor into revenue
    dock.log_hour
    dock.return(sup_1)
    dock.return(sup_2)

    assert_equal 195, dock.revenue
  end

end
