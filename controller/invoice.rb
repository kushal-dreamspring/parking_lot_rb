# frozen_string_literal: true

# class for Controller
class Controller
  def all_invoices
    Car.join(:invoices, car_id: :id).all
  end

  def invoice(invoice_id)
    Car.join(Invoice.where(id: invoice_id), car_id: :id).first
  end
end
