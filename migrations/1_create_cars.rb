# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table :cars do
      primary_key :id
      String :registration_number
    end
  end
end
