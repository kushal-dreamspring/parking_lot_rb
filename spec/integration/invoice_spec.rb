# frozen_string_literal: true

describe 'Invoice' do
  ParkingLot.initialize_app
  registration_number = 'UP32EA7196'
  invoice = ''

  before do
    DATABASE['UPDATE slots SET car_id = NULL, entry_time = NULL WHERE car_id IS NOT NULL']
    DATABASE['DELETE FROM cars']
    DATABASE['DELETE FROM invoices']
  end

  context 'when invoice does not exist' do
    it 'should return empty list' do
      invoices = ParkingLot.all_invoices

      expect(invoices.length).to eq(0)
    end

    it 'should return nil' do
      invoice = ParkingLot.invoice(1)
      expect(invoice).to be_nil
    end
  end

  context 'after car has been unparked' do
    before do
      ParkingLot.park_car(registration_number)
      slot_no = ParkingLot.get_slot_no(registration_number)
      invoice = ParkingLot.unpark_car(slot_no)
    end

    it 'should list all invoices' do
      invoices = ParkingLot.all_invoices

      expect(invoices.length).to eq(1)
    end

    it 'should list invoice of given invoice id' do
      new_invoice = ParkingLot.invoice(invoice[:id])

      expect(new_invoice[:id]).to eq(invoice[:id])
    end
  end
end
