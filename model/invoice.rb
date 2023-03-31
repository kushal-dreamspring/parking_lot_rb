# frozen_string_literal: true

# Class for Invoice
class Invoice < Sequel::Model DATABASE[:invoices]
  plugin :validation_helpers

  def self.invoice_amount(duration)
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
    duration = exit_time - entry_time
    invoice_amount = invoice_amount duration
    super(car_id:, entry_time:, duration:, invoice_amount:)
  end

  def validate
    validates_presence %i[car_id entry_time]
  end

end
