# frozen_string_literal: true

describe 'Park' do
  ParkingLot.initialize_app

  context 'when registration_number is invalid' do
    registration_number = 'UP32EA719'

    it 'should not park the car' do
      expect { ParkingLot.park_car(registration_number) }.to output("Registration Number is invalid\n").to_stdout
    end
  end

  context 'when car is not parked' do
    registration_number = 'UP32EA7196'

    it 'return the parking-slot-identifier' do
      response = ParkingLot.park_car(registration_number)

      expect(response).to eq(1)
    end

    it 'should assign the car to a parking slot, add entry time at parking' do
      ParkingLot.park_car(registration_number)

      response = DATABASE[:slots].select(:id).where(
        car_id: DATABASE[:cars].select(:id).where(registration_number:)
      ).call(:first)

      expect(response).not_to be_nil
    end
  end

  context 'when car is already parked' do
    registration_number = 'UP32EA7196'

    before do
      ParkingLot.park_car(registration_number)
    end

    it 'should not park a car' do
      expect { ParkingLot.park_car(registration_number) }.to output("Car already Parked\n").to_stdout
    end
  end
end
