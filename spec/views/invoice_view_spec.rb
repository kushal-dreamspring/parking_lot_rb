# frozen_string_literal: true

require_relative '../../views/invoice_view'
require_relative '../../model/invoice'

RSpec.describe InvoiceView do
  context 'when no car has been unparked' do
    it 'should print \'No Invoice Found\'' do
      expect { InvoiceView.print_invoice(nil) }
        .to output("No Invoice Found\n").to_stdout_from_any_process
    end

    it 'should print \'No Invoice Found\'' do
      expect { InvoiceView.print_all_invoices([]) }
        .to output("No Invoices Found\n").to_stdout_from_any_process
    end
  end

  context 'when a car has been unparked' do
    invoice_id = ''
    registration_number = 'UP32EA7196'

    before :each do
      system("RACK_ENV='test' ./app.rb -p #{registration_number}")
      response = `RACK_ENV="test" ./app.rb -u #{registration_number}`
      invoice_id = response.scan(/\d+/)[1].to_i
    end

    it 'display the invoice details' do
      invoice = Invoice.find(invoice_id).first
      invoice[:registration_number] = registration_number

      expect { InvoiceView.print_invoice(invoice) }
        .to output(
          /Invoice Details:\nInvoice number: (\d*)\nRegistration Number: [A-Za-z]{2}[a-zA-Z0-9]{8}
Entry Time: [\w,: ]* IST\nExit Time: [\w,: ]* IST\nDuration: (\d*) secs\nAmount: (\d*)/
        ).to_stdout_from_any_process
    end

    it 'list all the invoices' do
      expect { InvoiceView.print_all_invoices(Invoice.all) }
        .to output(
          /((\d*) [A-Za-z]{2}[a-zA-Z0-9]{8} ([\d:+ -]*) ([\d:+ -]*) (\d*) (\d*))*/
        ).to_stdout_from_any_process
    end
  end
end
