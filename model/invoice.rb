# frozen_string_literal: true

require_relative './car'

# Class for Invoice
class Invoice < Sequel::Model DATABASE[:invoices]
  plugin :validation_helpers

  def self.invoice_amount(entry_time, exit_time)
    duration = exit_time - entry_time

    if duration <= 10
      100
    elsif duration <= 30
      200
    elsif duration <= 60
      300
    else
      500
    end
  end

  def self.create(car_id, entry_time, exit_time = Time.now)
    invoice_amount = invoice_amount(entry_time, exit_time)
    super(car_id:, entry_time:, exit_time:, invoice_amount:)
  end

  def validate
    validates_presence %i[car_id entry_time]
  end

  def self.all_invoices
    join(Car.select(Sequel[:id].as(:car_id), :registration_number), car_id: :car_id).all
  end

  def self.find_by_id(invoice_id)
    where(id: invoice_id).join(
      Car.select(Sequel[:id].as(:car_id), :registration_number),
      car_id: :car_id
    ).first
  end
end
