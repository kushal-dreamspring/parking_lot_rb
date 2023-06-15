# frozen_string_literal: true

# class for Controller
class Controller
  def get_slot_no(registration_number)
    slot = Slot.where(
      car_id: DATABASE[:cars].select(:id).where(registration_number:)
    ).call(:first)

    return slot.id if slot

    nil
  end

  def unpark_car(slot_id)
    slot = Slot.where(id: slot_id).first
    invoice_id = Invoice.create(slot[:car_id], slot[:entry_time]).id
    invoice = Car.join(Invoice.where(id: invoice_id), car_id: :id).first

    slot.update(car_id: nil, entry_time: nil)
    invoice
  end
end
