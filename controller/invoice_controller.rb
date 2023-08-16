# frozen_string_literal: true

require_relative '../model/invoice'
require_relative '../model/car'
require_relative '../views/invoice_view'

# Controller Class for Invoice
class InvoiceController
  def all_invoices
    InvoiceView.print_all_invoices(Invoice.all_invoices)
  end

  def invoice(invoice_id)
    InvoiceView.print_invoice(Invoice.find_by_id(invoice_id))
  end
end
