require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/boat'

class BoatTest < Minitest::Test

  def test_if_it_exists
    kayak = Boat.new(:kayak, 20)

    assert_instance_of Boat, kayak
  end

  def test_it_has_attributes
    kayak = Boat.new(:kayak, 20)

    assert_equal :kayak, kayak.type
    assert_equal 20, kayak.price_per_hour
  end

end
