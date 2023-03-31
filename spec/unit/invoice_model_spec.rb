# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Invoice' do
  before do
    DATABASE['UPDATE slots SET car_id = NULL, entry_time = NULL WHERE car_id IS NOT NULL']
    DATABASE['DELETE FROM cars']
    DATABASE['DELETE FROM invoices']
  end

  context 'when car is not present' do
    it 'should raise a foreign key constraint error' do
      expect { Invoice.create(0, Time.now) }.to raise_error(Sequel::ForeignKeyConstraintViolation)
    end
  end

  context 'when car is present' do
    car_id = ''

    before do
      DATABASE['UPDATE slots SET car_id = NULL, entry_time = NULL WHERE car_id IS NOT NULL']
      DATABASE['DELETE FROM cars']
      DATABASE['DELETE FROM invoices']
      car_id = Car.create(registration_number: 'UP32EA6196')[:id]
    end

    context 'when car_id is nil' do
      it 'should throw a validation error' do
        expect { Invoice.create(nil, Time.now) }.to raise_error(Sequel::ValidationFailed)
      end
    end

    it 'should calculate duration correctly' do
      invoice = Invoice.create(car_id, Time.now, Time.now + 100)

      expect(invoice[:duration]).to eql(100)
    end

    it 'should calculate invoice amount correctly' do
      expect(Invoice.invoice_amount(10)).to eql(100)
      expect(Invoice.invoice_amount(30)).to eql(200)
      expect(Invoice.invoice_amount(60)).to eql(300)
      expect(Invoice.invoice_amount(61)).to eql(500)
    end
  end
end
