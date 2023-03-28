# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table :slots do
      primary_key :id
      foreign_key :car_id, :cars
      DateTime :entry_time
    end
  end
end
