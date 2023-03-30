# frozen_string_literal: true

# Controller module for Parking Lot
module ParkingLot
  def self.all_invoices
    DATABASE[:invoices].all
  end

  def self.invoice(invoice_id)
    DATABASE[:invoices].where(id: invoice_id).first
  end
end
