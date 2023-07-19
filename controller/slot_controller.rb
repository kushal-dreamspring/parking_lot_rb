# frozen_string_literal: true

require_relative '../model/slot'
require_relative '../model/car'
require_relative '../model/invoice'

require_relative '../views/slot_view'

# Controller Class for Slot
class SlotController
  def initialize(size = 10)
    return unless Slot.count.zero?

    size.times do
      Slot.create
    end
  end

  def park_car(registration_number)
    car_id = (Car.where(registration_number:).first || Car.create(registration_number:))[:id]
    slot = Slot.where(car_id: nil).order(:id).first

    raise 'Parking Lot is Full!!' unless slot

    slot.update(car_id:, entry_time: Time.now).save

    SlotView.car_parked(slot)
  rescue StandardError => e
    SlotView.car_parked(nil, e.message)
  end

  def find_and_unpark_car(registration_number)
    slot = get_slot(registration_number)

    SlotView.print_found_car(slot)

    InvoiceView.print_invoice(unpark_car(slot)) if slot
  end

  def all_parked_cars
    SlotView.print_all_parked_cars(Car.join(Slot.order(:id), car_id: :id).all)
  end

  def reset_db
    Slot.exclude(car_id: nil).update(car_id: nil, entry_time: nil)
    DATABASE[:invoices].delete
    DATABASE[:cars].delete
  end

  private

  def get_slot(registration_number)
    Slot.where(
      car_id: DATABASE[:cars].select(:id).where(registration_number:)
    ).call(:first)
  end

  def unpark_car(slot)
    invoice_id = Invoice.create(slot[:car_id], slot[:entry_time]).id
    invoice = Invoice.where(id: invoice_id).join(
      Car.select(Sequel[:id].as(:car_id), :registration_number),
      car_id: :car_id
    ).first

    slot.update(car_id: nil, entry_time: nil)
    invoice
  end
end
