# frozen_string_literal: true

describe 'Unpark' do
  controller = Controller.new

  context 'when car is not parked' do
    it 'should return that car not found' do
      registration_number = 'UP32EA7196'
      slot_id = controller.get_slot_no(registration_number)
      expect(slot_id).to be_nil
    end
  end

  context 'when car is parked' do
    registration_number = 'UP32EA7196'

    before do
      controller.park_car(registration_number)
    end

    it 'should find slot no of parked car' do
      slot = DATABASE[:slots].select(:id).where(
        car_id: DATABASE[:cars].select(:id).where(registration_number:)
      ).call(:first)
      expect(slot[:id]).to eq(controller.get_slot_no(registration_number))
    end

    it 'should unpark the car' do
      slot_no = controller.get_slot_no(registration_number)
      controller.unpark_car(slot_no)
      expect(DATABASE[:slots].select(:car_id).where(id: slot_no).call(:first)[:car_id]).to be_nil
    end

    it 'should return the invoice' do
      slot_no = controller.get_slot_no(registration_number)
      invoice = controller.unpark_car(slot_no)
      expect(invoice[:car_id]).not_to be_nil
    end
  end
end
