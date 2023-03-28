# frozen_string_literal: true

require 'time'
require 'sequel'

# Class for Invoice
class Invoice < Sequel::Model DATABASE[:invoices]
  def create(car, entry_time)
    @duration = Time.now - entry_time
    super(car, entry_time, duration:, invoice_amount:)
  end

  def validate
    validates_presence %i[car entry_time]
  end

  def invoice_amount
    if @duration <= 10
      100
    elsif @duration <= 30
      200
    elsif @duration <= 60
      300
    else
      500
    end
  end
end
