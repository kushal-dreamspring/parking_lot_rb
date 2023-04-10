# frozen_string_literal: true

# class for Controller
class Controller
  def all_invoices
    DATABASE[:invoices].join(:cars, id: :car_id).all
  end

  def invoice(invoice_id)
    DATABASE[:cars].join(DATABASE[:invoices].where(id: invoice_id), car_id: :id).first
  end
end
