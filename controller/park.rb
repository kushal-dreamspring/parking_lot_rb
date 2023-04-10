# frozen_string_literal: true

# class for Controller
class Controller
  def park_car(registration_number)
    car_id = (Car.where(registration_number:).first || Car.create(registration_number:))[:id]
    slot = Slot.where(car_id: nil).order(:id).first.update(car_id:, entry_time: Time.now).save

    puts "Car successfully parked at #{slot.id}!!"
  rescue Sequel::ValidationFailed => e
    if e.message == 'car_id is already taken'
      puts 'Car already Parked'
    elsif e.message == 'registration_number is invalid'
      puts 'Registration Number is invalid'
    else
      puts e.message
    end
  end
end
