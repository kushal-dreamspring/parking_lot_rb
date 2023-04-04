# frozen_string_literal: true

# Controller module for Parking Lot
module ParkingLot
  def self.all_invoices
    DATABASE[:invoices].join(:cars, id: :car_id).all
  end

  def self.invoice(invoice_id)
    DATABASE[:cars].join(DATABASE[:invoices].where(id: invoice_id), car_id: :id).first
  end
end
