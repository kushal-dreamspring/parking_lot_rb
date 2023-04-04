# frozen_string_literal: true

# Controller module for Parking Lot
module ParkingLot
  def self.all_parked_cars
    Slot.exclude(car_id: nil).join(:cars, id: :car_id).all
  end
end
