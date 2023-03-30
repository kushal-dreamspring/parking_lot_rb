# frozen_string_literal: true

# Controller module for Parking Lot
module ParkingLot
  def self.park_car(registration_number)
    begin
      car = Car.where(registration_number:).first
      car = Car.create(registration_number:) if car.nil?

      slot = Slot.where(car_id: nil).order(:id).first.update(car_id: car.id, entry_time: Time.now).save

      slot.id
    rescue Sequel::ValidationFailed => e
      case e.message
      when 'car_id is already taken' then 'Car already Parked'
      else
        e.message
      end
    end
  end
end
