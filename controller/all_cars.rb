# frozen_string_literal: true

# Controller module for Parking Lot
module ParkingLot
  def self.all_parked_cars
    DATABASE[:slots].exclude(car_id: nil).all
  end
end
