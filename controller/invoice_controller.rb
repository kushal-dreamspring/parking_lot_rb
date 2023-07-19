# frozen_string_literal: true

require_relative '../model/invoice'
require_relative '../model/car'

require_relative '../views/invoice_view'

# Controller Class for Invoice
class InvoiceController
  def all_invoices
    InvoiceView.print_all_invoices(
      Invoice.join(Car.select(Sequel[:id].as(:car_id), :registration_number), car_id: :car_id).all
    )
  end

  def invoice(invoice_id)
    InvoiceView.print_invoice(Invoice.where(id: invoice_id).join(
      Car.select(Sequel[:id].as(:car_id), :registration_number),
      car_id: :car_id
    ).first)
  end
end
