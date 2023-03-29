# frozen_string_literal: true

# Controller module for Parking Lot
module ParkingLot
  def self.park_car(registration_number)
    car = Car.where(registration_number:).first
    car = Car.create(registration_number:) if car.nil?

    slot = Slot.where(car_id: nil).first.update(car_id: car.id, entry_time: Time.now)
    slot.save

    "car parked at #{slot.id}"
  rescue Sequel::ValidationFailed => e
    e.message
  end
end
