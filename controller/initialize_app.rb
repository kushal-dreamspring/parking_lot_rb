# frozen_string_literal: true

# Controller module for Parking Lot
module ParkingLot
  def self.initialize_app
    return unless Slot.count.zero?

    10.times do
      Slot.create
    end
  end
end