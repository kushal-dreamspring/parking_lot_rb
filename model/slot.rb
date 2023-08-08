# frozen_string_literal: true
require_relative '../model/invoice'

# Class for Parking Slot
class Slot < Sequel::Model DATABASE[:slots]
  plugin :validation_helpers

  def validate
    super
    validates_unique :car_id
  end

  def park_car_in_slot(car_id)
    update(car_id:, entry_time: Time.now)
    save
  end

  def self.get_slot(registration_number)
    where(
      car_id: DATABASE[:cars].select(:id).where(registration_number:)
    ).call(:first)
  end

  def self.find_empty_slot
    where(car_id: nil).order(:id).first
  end

  def unpark_car
    invoice_id = Invoice.create(car_id, entry_time).id
    invoice = Invoice.find_by_id(invoice_id)

    update(car_id: nil, entry_time: nil)
    invoice
  end
end
