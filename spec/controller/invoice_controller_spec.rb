# frozen_string_literal: true

require_relative '../../controller/invoice_controller'

RSpec.describe InvoiceController do
  controller = InvoiceController.new

  context 'when no car has been unparked' do
    it 'should find zero invoices' do
      expect(InvoiceView).to receive(:print_all_invoices).with([])

      controller.all_invoices
    end

    it 'should not find a invoice' do
      expect(InvoiceView).to receive(:print_invoice).with(nil)
      controller.invoice(1)
    end
  end

  context 'after car has been unparked' do
    registration_number = 'UP32EA7196'
    invoice_id = nil

    before do
      system("RACK_ENV='test' ./app.rb -p #{registration_number}")
      response = `echo | RACK_ENV="test" ./app.rb -u UP32EA7196`
      invoice_id = response.scan(/\d+/)[1].to_i
    end

    it 'should list all invoices' do
      expect(InvoiceView).to receive(:print_all_invoices).with(
        an_instance_of(Array).and(have_attributes(length: 1))
      )

      controller.all_invoices
    end

    it 'should return invoice of given invoice id' do
      expect(InvoiceView).to receive(:print_invoice).with(
        an_instance_of(Invoice).and(have_attributes(values: hash_including(registration_number:)))
      )
      controller.invoice(invoice_id)
    end
  end
end
