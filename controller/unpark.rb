# frozen_string_literal: true

# Controller module for Parking Lot
module ParkingLot
  def self.get_slot_no(registration_number)
    slot = Slot.where(
      car_id: DATABASE[:cars].select(:id).where(registration_number:)
    ).call(:first)

    return slot.id if slot

    nil
  end

  def self.unpark_car(slot_id)
    slot = Slot.where(id: slot_id).first
    invoice = Invoice.create(slot[:car_id], slot[:entry_time])

    slot.update(car_id: nil, entry_time: nil)
    invoice
  end
end
