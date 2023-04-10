# frozen_string_literal: true

describe 'Invoice' do
  controller = Controller.new
  registration_number = 'UP32EA7196'
  invoice = ''

  context 'when invoice does not exist' do
    it 'should return empty list' do
      invoices = controller.all_invoices

      expect(invoices.length).to eq(0)
    end

    it 'should return nil' do
      invoice = controller.invoice(1)
      expect(invoice).to be_nil
    end
  end

  context 'after car has been unparked' do
    before do
      controller.park_car(registration_number)
      slot_no = controller.get_slot_no(registration_number)
      invoice = controller.unpark_car(slot_no)
    end

    it 'should list all invoices' do
      invoices = controller.all_invoices

      expect(invoices.length).to eq(1)
    end

    it 'should list invoice of given invoice id' do
      new_invoice = controller.invoice(invoice[:id])

      expect(new_invoice[:id]).to eq(invoice[:id])
    end
  end
end
