# frozen_string_literal: true

# class for Controller
class Controller
  def all_parked_cars
    Slot.exclude(car_id: nil).join(:cars, id: :car_id).all
  end
end
