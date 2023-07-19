# frozen_string_literal: true

# View Class for Slot
module SlotView
  def self.car_parked(slot, err = nil)
    if err
      return case err
             when 'car_id is already taken'
               puts 'Car already Parked'
             when 'registration_number is invalid'
               puts 'Registration Number is invalid'
             else
               puts err
             end
    end
    puts "Car successfully parked at #{slot.id}!!"
  end

  def self.print_found_car(slot)
    if slot
      puts "Car was parked at #{slot.id}"
    else
      puts 'Car not found'
    end
  end

  def self.print_all_parked_cars(cars)
    if cars.empty?
      puts 'No Cars Found'
    else
      puts "Slot ID\tRegistration Number\tEntry Time"
      cars.each do |car|
        puts "#{car[:id]}\t#{car[:registration_number]}\t\t#{car[:entry_time].strftime('%B %d, %Y %T IST')}"
      end
    end
  end
end
