# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table :invoices do
      primary_key :id
      foreign_key :car_id, :cars
      DateTime :entry_time
      DateTime :exit_time, default: Sequel::CURRENT_TIMESTAMP
      int :duration
      int :invoice_amount
    end
  end
end
