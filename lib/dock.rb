require 'pry'

class Dock

  attr_reader :name, :max_rental_time, :rental_log, :return_flag

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @return_flag = Hash.new(0)
  end

  def rent(boat, renter)
    rental_log[boat] = renter
  end

  def charge(boat)
    { :card_number => credit_card(boat), :amount => amount(boat) }
  end

  def credit_card(boat)
    find_boat(boat).last.credit_card_number
  end

  def find_boat(boat)
    rental_log.find { |type, name| type == boat }
  end

  def amount(boat)
    pph(boat) * adjusted_hours(boat)
  end

  def pph(boat)
    find_boat(boat).first.price_per_hour
  end

  def adjusted_hours(boat)
    [hours(boat), max_rental_time].min
  end

  def hours(boat)
    find_boat(boat).first.hours_rented
  end

  def log_hour
    rental_log.each { |boat, renter| boat.add_hour }
  end

  def revenue
    rental_log.keys.reduce(0) do |sum, boat|
      return 0 if self.return_flag[boat] != 1
      sum + charge(boat)[:amount]
    end
  end

  def return(boat)
    return_flag[boat] = 1
  end

end
