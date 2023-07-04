# frozen_string_literal: true

# class for Controller
class Controller
  def all_parked_cars
    Car.join(Slot.order(:id), car_id: :id).all
  end
end
