# frozen_string_literal: true

describe 'All Cars' do
  ParkingLot.initialize_app

  context 'when cars does not exist' do
    before do
      DATABASE['update slots set car_id = NULL, entry_time = NULL where car_id is not null']
      DATABASE['DELETE FROM cars']
    end

    it 'should return empty list' do
      cars = ParkingLot.all_parked_cars

      expect(cars.length).to eq(0)
    end
  end

  context 'when car has been parked' do
    slot_id = ''

    before do
      DATABASE['update slots set car_id = NULL, entry_time = NULL where car_id is not null']
      DATABASE['DELETE FROM cars']
      slot_id = ParkingLot.park_car('UP32EA7196')
    end

    it 'should list all cars' do
      cars = ParkingLot.all_parked_cars

      expect(cars.length).to eq(1)
      expect(cars[0][:id]).to eq(slot_id)
    end
  end
end
