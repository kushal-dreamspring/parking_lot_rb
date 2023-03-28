# frozen_string_literal: true

require 'time'
require 'sequel'

DATABASE = Sequel.connect('postgres://localhost:5432/test')

require_relative '../model/car'
require_relative '../model/invoice'
require_relative '../model/slot'

# Controller module for parking
module Park
  def self.initialize_app
    p Slot.count
    return unless Slot.count.zero?

    10.times do
      Slot.create
    end
  end

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
