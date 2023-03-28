# frozen_string_literal: true

require 'sequel'

# Class for Car
class Car < Sequel::Model DATABASE[:cars]
  plugin :validation_helpers

  def validate
    super
    validates_presence :registration_number
    validates_unique :registration_number, message: 'car already exists'
    validates_format(/^[A-Za-z]{2}\w{8}$/, :registration_number, message: 'is invalid')
  end
end
