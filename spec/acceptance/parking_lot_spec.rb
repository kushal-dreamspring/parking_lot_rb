# frozen_string_literal: true

require 'time'
require 'sequel'

DATABASE = Sequel.connect('sqlite://db/test.sqlite')

require_relative '../../model/car'
require_relative '../../model/invoice'
require_relative '../../model/slot'
require_relative '../../controller/all_cars'
require_relative '../../controller/initialize_app'
require_relative '../../controller/invoice'
require_relative '../../controller/park'
require_relative '../../controller/unpark'

RSpec.describe 'Parking' do
  describe 'Park Car' do
    context 'when no car is parked' do
      it 'should park a car' do
        expect { system('RACK_ENV="test" ./app.rb -p UP32EA7196') }
          .to output(/Car successfully parked at \d!!/).to_stdout_from_any_process
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
        expect { system('RACK_ENV="test" ./app.rb -p UP32EA7196') }
          .to output(/Parking Lot is Full!!/).to_stdout_from_any_process
      end
    end
  end

  describe 'Unpark Car' do
    context 'when no car is parked' do
      it 'should print \'car not found\'' do
        expect { system('echo | RACK_ENV="test" ./app.rb -u UP32EA7196') }
          .to output(/car not found/).to_stdout_from_any_process
      end
    end

    context 'when a car is parked' do
      before :each do
        system('RACK_ENV="test" ./app.rb -p UP32EA7196')
      end

      it 'should unpark a parked car and generate invoice' do
        expect { system('echo | RACK_ENV="test" ./app.rb -u UP32EA7196') }
          .to output(
            %r{Car parked at \d\nDo you want to unpark it\? \(Y/n\)\n\nInvoice Details:
Invoice number: (\d*)\nRegistration Number: (\d*)\nEntry Time: ([\d:+ -]*)\nExit Time: ([\d:+ -]*)
Duration: (\d*)\nAmount: (\d*)}
          ).to_stdout_from_any_process
      end
    end
  end

  describe 'Invoice' do
    context 'when no invoice is present' do
      it 'should print \'No Invoice Found\'' do
        expect { system('RACK_ENV="test" ./app.rb -i 1') }
          .to output("Invoice Not Found\n").to_stdout_from_any_process
      end
    end

    context 'when a car has been unparked' do
      invoice_id = ''

      before :each do
        system('RACK_ENV="test" ./app.rb -p UP32EA7196')
        response = `echo | RACK_ENV="test" ./app.rb -u UP32EA7196`
        invoice_id = response.scan(/\d+/)[1].to_i
      end

      it 'display the invoice details' do
        expect { system("RACK_ENV=\"test\" ./app.rb -i #{invoice_id}") }
          .to output(
            /Invoice Details:\nInvoice number: (\d*)\nRegistration Number: [A-Za-z]{2}[a-zA-Z0-9]{8}
Entry Time: ([\d:+ -]*)\nExit Time: ([\d:+ -]*)\nDuration: (\d*)\nAmount: (\d*)/
              ).to_stdout_from_any_process
      end
    end
  end

  describe 'All Parked Cars' do
    context 'when no car is parked' do
      it 'should print \'No Car Found\'' do
        expect { system('RACK_ENV="test" ./app.rb --all-cars') }
          .to output("No Car Found\n").to_stdout_from_any_process
      end
    end

    context 'when a car is parked' do
      before :each do
        system('RACK_ENV="test" ./app.rb -p UP32EA7196')
      end

      it 'list all the cars in the parking lot' do
        expect { system('RACK_ENV="test" ./app.rb --all-cars') }
          .to output(
            /Slot ID\tRegistration Number\tEntry Time
((\d*) [A-Za-z]{2}[a-zA-Z0-9]{8} ([\d:+ -]*))*/
              ).to_stdout_from_any_process
      end
    end
  end

  describe 'All Invoice' do
    context 'when no car is parked' do
      it 'should print \'No Invoice Found\'' do
        expect { system('RACK_ENV="test" ./app.rb --all-invoices') }
          .to output("No Invoice Found\n").to_stdout_from_any_process
      end
    end

    context 'when a car has been unparked' do
      before :each do
        system('RACK_ENV="test" ./app.rb -p UP32EA7196')
        system('echo | RACK_ENV="test" ./app.rb -u UP32EA7196')
      end

      it 'list all the invoices' do
        expect { system('RACK_ENV="test" ./app.rb --all-invoices') }
          .to output(
            /Invoice number\tRegistration Number\tEntry Time\t\t\tExit Time\t\t\tDuration\tAmount
((\d*) [A-Za-z]{2}[a-zA-Z0-9]{8} ([\d:+ -]*) ([\d:+ -]*) (\d*) (\d*))*/
              ).to_stdout_from_any_process
      end
    end
  end
end
