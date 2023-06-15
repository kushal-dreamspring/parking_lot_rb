# frozen_string_literal: true

# class for Controller
class Controller
  def all_parked_cars
    Car.join(Slot.exclude(car_id: nil), car_id: :id).all
  end
end
