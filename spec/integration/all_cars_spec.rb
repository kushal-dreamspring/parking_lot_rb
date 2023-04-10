# frozen_string_literal: true

describe 'All Cars' do
  controller = Controller.new

  context 'when cars does not exist' do
    it 'should return empty list' do
      cars = controller.all_parked_cars

      expect(cars.length).to eq(0)
    end
  end

  context 'when car has been parked' do
    before do
      controller.park_car('UP32EA7196')
    end

    it 'should list all cars' do
      cars = controller.all_parked_cars

      expect(cars.length).to eq(1)
      expect(cars[0][:registration_number]).to eq('UP32EA7196')
    end
  end
end
