# frozen_string_literal: true

require 'time'
require 'sequel'

DATABASE = Sequel.connect('postgres://localhost:5432/test')

require_relative '../../model/car'
require_relative '../../model/invoice'
require_relative '../../model/slot'
require_relative '../../controller/all_cars'
require_relative '../../controller/initialize_app'
require_relative '../../controller/invoice'
require_relative '../../controller/park'
require_relative '../../controller/unpark'

RSpec.describe 'Parking' do
  it 'should park a car' do
    pending 'Not yet implemented'
    response = ''
    expect(response).to eq('Car Parked Successfully')
  end

  it 'should find the car parked' do
    pending 'Not yet implemented'
    response = ''
    expect(response).to eq('Invalid Car Registration Number')
  end

  it 'list all the cars in the parking lot' do
    pending 'Not yet implemented'
    response = ''
    expect(response).to eq('Slot already occupied')
  end
end

RSpec.describe 'Invoice' do
  it 'should generate an invoice when the car unparked' do
    pending 'Not yet implemented'
    response = ''
    expect(response).to eq('Invalid Car Registration Number')
  end

  it 'list all the invoices' do
    pending 'Not yet implemented'
    response = ''
    expect(response).to eq('Slot already occupied')
  end

  it 'display the invoice details' do
    pending 'Not yet implemented'
    response = ''
    expect(response).to eq('Slot already occupied')
  end
end
