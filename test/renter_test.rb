require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/renter'

class RenterTest < Minitest::Test

  def test_if_it_exists
    renter = Renter.new("Patrick Star", "4242424242424242")

    assert_instance_of Renter, renter
  end

  def test_if_it_has_attributes
    renter = Renter.new("Patrick Star", "4242424242424242")

    assert_equal "Patrick Star", renter.name
    assert_equal "4242424242424242", renter.credit_card_number
  end

end
