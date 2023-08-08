# frozen_string_literal: true

require_relative '../../model/invoice'

RSpec.describe 'Invoice' do
  context 'when car is not present' do
    it 'should raise a foreign key constraint error' do
      expect { Invoice.create(0, Time.now) }.to raise_error(Sequel::ForeignKeyConstraintViolation)
    end
  end

  context 'when car is present' do
    car_id = ''

    before do
      car_id = Car.create(registration_number: 'UP32EA6196')[:id]
    end

    context 'when car_id is nil' do
      it 'should throw a validation error' do
        expect { Invoice.create(nil, Time.now) }.to raise_error(Sequel::ValidationFailed)
      end
    end

    it 'should calculate invoice amount correctly' do
      expect(Invoice.invoice_amount(Time.now, Time.now + 5)).to eql(100)
      expect(Invoice.invoice_amount(Time.now, Time.now + 25)).to eql(200)
      expect(Invoice.invoice_amount(Time.now, Time.now + 55)).to eql(300)
      expect(Invoice.invoice_amount(Time.now, Time.now + 100)).to eql(500)
    end
  end

  context 'when invoice is present' do
    registration_number = 'UP32EA6196'
    invoice_id = ''

    before do
      invoice_id = Invoice.create(Car.create(registration_number:).id, Time.now).id
    end

    it 'should return invoice with car registration number' do
      invoice = Invoice.find_by_id(invoice_id)
      expect(invoice[:registration_number]).to eql(registration_number)
    end
  end
end
