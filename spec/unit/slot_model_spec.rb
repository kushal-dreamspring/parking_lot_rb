# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Slot' do
  context 'when car is already parked' do
    car_id = ''

    before do
      DATABASE['UPDATE slots SET car_id = NULL, entry_time = NULL WHERE car_id IS NOT NULL']
      DATABASE['DELETE FROM cars']
      car_id = Car.create(registration_number: 'UP32EA6196')[:id]
      Slot.where(car_id: nil).order(:id).first.update(car_id:, entry_time: Time.now).save
    end

    it 'should throw validation error' do
      expect do
        Slot.where(car_id: nil).order(:id).first.update(car_id:, entry_time: Time.now).save
      end.to raise_error(Sequel::ValidationFailed)
    end
  end
end
