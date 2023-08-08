# frozen_string_literal: true

require_relative '../../model/slot'

RSpec.describe Slot do
  context 'when no car is parked' do
    registration_number = 'UP32EA6196'
    car_id = ''

    before do
      car_id = Car.create(registration_number:)[:id]
    end

    it 'should find a empty slot' do
      empty_slot = Slot.find_empty_slot
      expect(empty_slot.car_id).to be_nil
    end

    it 'should park the car and return the slot' do
      slot = Slot.find_empty_slot
      slot.park_car_in_slot(car_id)

      expect(slot.car_id).to be(car_id)
    end

    it 'should find no car' do
      expect(Slot.get_slot(registration_number)).to be_nil
    end
  end

  context 'when car is already parked' do
    slot = ''
    registration_number = 'UP32EA6196'

    before do
      car_id = Car.create(registration_number:)[:id]
      slot = Slot.find_empty_slot.park_car_in_slot(car_id)
    end

    it 'should get slot of parked car' do
      expect(Slot.get_slot(registration_number).id).to be(slot.id)
    end

    it 'should find and unpark the car and return invoice' do
      expect(slot.unpark_car.id).not_to be_nil
    end
  end
end
