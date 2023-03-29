# frozen_string_literal: true

require_relative '../../model/car'
require_relative '../../model/invoice'
require_relative '../../model/slot'
require_relative '../../controller/initialize_app'
require_relative '../../controller/park'
require_relative '../../controller/unpark'

describe 'Initialize_app' do

  context 'when slots table is empty' do
    before do
      DATABASE['DELETE FROM slots']
    end

    it 'should insert 10 rows' do
      ParkingLot.initialize_app
      expect(DATABASE[:slots].count).to eq(10)
    end
  end

  context 'when slots table has 10 rows' do
    before do
      DATABASE['DELETE FROM slots']
      ParkingLot.initialize_app
    end

    it 'should not insert any rows' do
      ParkingLot.initialize_app
      expect(DATABASE[:slots].count).to eq(10)
    end
  end
end
