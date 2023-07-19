# frozen_string_literal: true

require_relative '../../controller/slot_controller'
require_relative '../../views/slot_view'
require_relative '../../views/invoice_view'

RSpec.describe SlotController do
  controller = SlotController.new
  registration_number = 'UP32EA7196'

  it 'should have 10 slots' do
    expect(Slot.count).to eq(10)
  end

  context 'when no car is parked' do
    it 'should park the car and return the parking-slot-identifier' do
      expect(SlotView).to receive(:car_parked).with(an_instance_of(Slot).and(have_attributes(id: 1)))

      controller.park_car(registration_number)
    end

    it 'should find no car while unparking' do
      expect(SlotView).to receive(:print_found_car).with(nil)

      controller.find_and_unpark_car(registration_number)
    end

    it 'should find no cars' do
      expect(SlotView).to receive(:print_all_parked_cars).with([])

      controller.all_parked_cars
    end
  end

  context 'when a car is parked' do
    before do
      system("RACK_ENV='test' ./app.rb -p #{registration_number}")
    end

    it 'should not park the same car' do
      expect(SlotView).to receive(:car_parked).with(nil, 'car_id is already taken')

      controller.park_car(registration_number)
    end

    it 'should find and unpark the car and return invoice' do
      expect(SlotView).to receive(:print_found_car).with(an_instance_of(Slot).and(have_attributes(id: 1)))
      expect(InvoiceView).to receive(:print_invoice).with(
        an_instance_of(Invoice).and(have_attributes(values: hash_including(registration_number:)))
      )

      controller.find_and_unpark_car(registration_number)
    end

    it 'should find all parked cars' do
      expect(SlotView).to receive(:print_all_parked_cars).with(an_instance_of(Array).and(have_attributes(length: 1)))

      controller.all_parked_cars
    end
  end

  context 'when parking lot is full' do
    before :each do
      system('RACK_ENV="test" ./app.rb -p UP32EA7190')
      system('RACK_ENV="test" ./app.rb -p UP32EA7191')
      system('RACK_ENV="test" ./app.rb -p UP32EA7192')
      system('RACK_ENV="test" ./app.rb -p UP32EA7193')
      system('RACK_ENV="test" ./app.rb -p UP32EA7194')
      system('RACK_ENV="test" ./app.rb -p UP32EA7195')
      system('RACK_ENV="test" ./app.rb -p UP32EA7196')
      system('RACK_ENV="test" ./app.rb -p UP32EA7197')
      system('RACK_ENV="test" ./app.rb -p UP32EA7198')
      system('RACK_ENV="test" ./app.rb -p UP32EA7199')
    end

    it 'should print parking lot is full' do
      expect(SlotView).to receive(:car_parked).with(nil, 'Parking Lot is Full!!')

      controller.park_car(registration_number)
    end
  end
end
