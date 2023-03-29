# frozen_string_literal: true

require_relative '../../model/car'
require_relative '../../model/invoice'
require_relative '../../model/slot'
require_relative '../../controller/initialize_app'
require_relative '../../controller/park'

describe 'Park' do
  ParkingLot.initialize_app

  context 'when registration_number is invalid' do
    registration_number = 'UP32EA719'

    before do
      DATABASE['update slots set car_id = NULL, entry_time = NULL where car_id is not null']
    end

    it 'should not park the car' do
      response = ParkingLot.park_car(registration_number)

      expect(response).to eq('registration_number is invalid')
    end
  end

  context 'when car is not parked' do
    registration_number = 'UP32EA7196'

    before do
      DATABASE['update slots set car_id = NULL, entry_time = NULL where car_id is not null'].update
      ds = DATABASE['SELECT * FROM slots where car_id IS NOT NULL']
      ds.each { |r| puts r[:car_id] }
    end

    it 'return the parking-slot-identifier' do
      response = ParkingLot.park_car(registration_number)

      expect(response).to match(/car parked at \d/)
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
      DATABASE['update slots set car_id = NULL, entry_time = NULL where car_id is not null']
      ParkingLot.park_car(registration_number)
    end

    it 'should not park a car' do
      response = ParkingLot.park_car(registration_number)

      expect(response).to eq('car_id is already parked')
    end
  end
end
