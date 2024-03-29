# frozen_string_literal: true

require_relative '../../model/car'

RSpec.describe 'Car' do
  context 'when registration number is not present' do
    it 'should throw validation error' do
      expect { Car.create(registration_number: nil) }.to raise_error(Sequel::ValidationFailed)
    end
  end

  context 'when registration number is invalid' do
    registration_number1 = 'UP32EA719'
    registration_number2 = 'UP 32 EA 7'
    registration_number3 = '0132BH9004'
    registration_number4 = 'UP_32_EA_9'

    it 'should throw validation error' do
      expect { Car.create(registration_number: registration_number1) }.to raise_error(Sequel::ValidationFailed)
      expect { Car.create(registration_number: registration_number2) }.to raise_error(Sequel::ValidationFailed)
      expect { Car.create(registration_number: registration_number3) }.to raise_error(Sequel::ValidationFailed)
      expect { Car.create(registration_number: registration_number4) }.to raise_error(Sequel::ValidationFailed)
    end
  end

  context 'when car is already present' do
    registration_number = 'UP32EA7196'
    car_id = ''

    before do
      car_id = Car.create(registration_number:).id
    end

    it 'should throw validation error' do
      expect { Car.create(registration_number:) }.to raise_error(Sequel::ValidationFailed)
    end

    it 'should get the existing car' do
      expect(Car.get_or_create(registration_number)).to be(car_id)
    end
  end
end
