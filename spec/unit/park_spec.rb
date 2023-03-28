# frozen_string_literal: true

require_relative '../../controller/park'

describe 'Park' do
  Park.initialize_app

  it 'should not park a car with invalid number' do
    registration_number = 'UP32EA719'
    response = Park.park_car(registration_number)

    expect(response).to eq('registration_number is invalid')
  end

  it 'return the parking-slot-identifier' do
    registration_number = 'UP32EA7196'
    response = Park.park_car(registration_number)

    expect(response).to match(/car parked at \d/)
  end

  it 'should assign the car to a parking slot, add entry time at parking' do
    registration_number = 'UP32EA7196'
    Park.park_car(registration_number)

    puts response = DATABASE[:slots].where(car_id: DATABASE[:cars].select(:id).where(registration_number:)).count

    expect(response).to eq(1)
  end

  it 'should not park a car twice' do
    registration_number = 'UP32EA7196'
    Park.park_car(registration_number)
    response = Park.park_car(registration_number)

    puts response

    expect(response).to eq('car_id is already parked')
  end
end
