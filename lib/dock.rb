class Dock

  attr_reader :name, :max_rental_time, :rental_log, :return_flag, :total_revenue

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @return_flag = Hash.new(0)
    @total_revenue = 0
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
    rental_log.each do |boat, renter|
      boat.add_hour if return_flag[boat] == 0
    end
  end

  def revenue
    rental_log.keys.each { |boat| flag_conditional(boat) }
    total_revenue
  end

  def flag_conditional(boat)
    if return_flag[boat] == 1
      @total_revenue += charge(boat)[:amount]
    end
  end

  def return(boat)
    return_flag[boat] = 1
  end

end
