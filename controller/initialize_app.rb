# frozen_string_literal: true

# Controller module for Parking Lot
module ParkingLot
  def self.initialize_app
    return unless Slot.count.zero?

    10.times do
      Slot.create
    end
  end

  def self.reset_db
    DATABASE[:slots].exclude(car_id: nil).update(car_id: nil, entry_time: nil)
    DATABASE[:invoices].delete
    DATABASE[:cars].delete
  end
end
