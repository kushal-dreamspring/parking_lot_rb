# frozen_string_literal: true

# Class for Parking Slot
class Slot < Sequel::Model DATABASE[:slots]
  plugin :validation_helpers

  def validate
    super
    validates_unique :car_id, message: 'is already parked'
  end
end
