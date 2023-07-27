# frozen_string_literal: true
require_relative '../model/invoice'

# Class for Parking Slot
class Slot < Sequel::Model DATABASE[:slots]
  plugin :validation_helpers

  def validate
    super
    validates_unique :car_id
  end

  def self.get_slot(registration_number)
    where(
      car_id: DATABASE[:cars].select(:id).where(registration_number:)
    ).call(:first)
  end

  def self.unpark_car(slot)
    invoice_id = Invoice.create(slot[:car_id], slot[:entry_time]).id
    invoice = Invoice.where(id: invoice_id).join(
      Car.select(Sequel[:id].as(:car_id), :registration_number),
      car_id: :car_id
    ).first

    slot.update(car_id: nil, entry_time: nil)
    invoice
  end
end
