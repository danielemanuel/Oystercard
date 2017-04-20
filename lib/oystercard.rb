
class Oystercard

  attr_reader :balance, :entry_station

  def initialize(balance = 0)
    @balance = balance
  end

  def top_up(amount = 0)
    raise "Top-up over max balance £#{MAX_BALANCE}" if exceed_balance?(amount)
    increment_balance(amount)
  end

  def in_journey?
    !entry_station.nil?
  end

  def touch_in(station)
    raise 'Not enough funds' if balance < LOW_BALANCE
    raise 'Already travelling' if in_journey?
    store_entry_station(station)
  end

  def touch_out
    raise 'ERROR! Not travelling!' if !in_journey?
    deduct(FARE)
    reset_entry_station
  end

  private

  attr_writer :balance, :entry_station

  MAX_BALANCE = 100
  LOW_BALANCE = 1
  FARE = 2

  def exceed_balance?(amount)
    self.balance + amount > MAX_BALANCE
  end

  def increment_balance(amount)
    self.balance += amount
  end

  def deduct(fare)
    self.balance -= fare
  end

  def store_entry_station(station)
      self.entry_station = station
  end

  def reset_entry_station
    self.entry_station = nil
  end

end
