# frozen_string_literal: true

require_relative '../../views/slot_view'
require_relative '../../model/slot'
require_relative '../../model/car'

RSpec.describe 'SlotView' do
  registration_number = 'UP32EA7196'

  context 'when no car is parked' do
    it 'should park a car' do
      expect { SlotView.car_parked(Slot.find(1).first) }
        .to output(/Car successfully parked at 1!!/)
        .to_stdout_from_any_process
    end

    it 'should print \'Car not found\'' do
      expect { SlotView.print_found_car(nil) }
        .to output(/Car not found/).to_stdout_from_any_process
    end

    it 'should print \'No Cars Found\'' do
      expect { SlotView.print_all_parked_cars([]) }
        .to output("No Cars Found\n").to_stdout_from_any_process
    end
  end

  context 'when a car is parked' do
    before :each do
      system("RACK_ENV='test' ./app.rb -p #{registration_number}")
    end

    it 'should print Car already Parked' do
      expect { SlotView.car_parked(nil, 'car_id is already taken') }
        .to output(/Car already Parked/)
        .to_stdout_from_any_process
    end

    it 'should print slot number of parked car' do
      expect { SlotView.print_found_car(Slot.find(1).first) }
        .to output(/Car was parked at 1/)
        .to_stdout_from_any_process
    end

    it 'list all the cars in the parking lot' do
      expect { SlotView.print_all_parked_cars(Car.join(Slot.order(:id), car_id: :id).all) }
        .to output(/((\d*) [A-Za-z]{2}[a-zA-Z0-9]{8} ([\d:+ -]*))*/)
        .to_stdout_from_any_process
    end
  end

  context 'when parking lot is full' do
    before :each do
      system('RACK_ENV="test" ./app.rb -p UP32EA7190')
      system('RACK_ENV="test" ./app.rb -p UP32EA7191')
      system('RACK_ENV="test" ./app.rb -p UP32EA7192')
      system('RACK_ENV="test" ./app.rb -p UP32EA7193')
      system('RACK_ENV="test" ./app.rb -p UP32EA7194')
      system('RACK_ENV="test" ./app.rb -p UP32EA7195')
      system('RACK_ENV="test" ./app.rb -p UP32EA7196')
      system('RACK_ENV="test" ./app.rb -p UP32EA7197')
      system('RACK_ENV="test" ./app.rb -p UP32EA7198')
      system('RACK_ENV="test" ./app.rb -p UP32EA7199')
    end

    it 'should print parking lot is full' do
      expect { SlotView.car_parked(nil, 'Parking Lot is Full!!') }
        .to output(/Parking Lot is Full!!/).to_stdout_from_any_process
    end
  end
end
