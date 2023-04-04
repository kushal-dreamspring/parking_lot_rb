# frozen_string_literal: true

describe 'All Cars' do
  ParkingLot.initialize_app

  context 'when cars does not exist' do
    it 'should return empty list' do
      cars = ParkingLot.all_parked_cars

      expect(cars.length).to eq(0)
    end
  end

  context 'when car has been parked' do
    slot_id = ''

    before do
      slot_id = ParkingLot.park_car('UP32EA7196')
    end

    it 'should list all cars' do
      cars = ParkingLot.all_parked_cars

      expect(cars.length).to eq(1)
      expect(cars[0][:registration_number]).to eq('UP32EA7196')
    end
  end
end
