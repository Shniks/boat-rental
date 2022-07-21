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

end
