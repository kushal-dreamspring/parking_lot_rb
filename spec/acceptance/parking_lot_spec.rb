# frozen_string_literal: true

require 'time'
require 'sequel'

DATABASE = Sequel.connect('postgres://postgres:7dgA7ycUvtPxVm4@parking-lot.cmwearec5mjd.ap-south-1.rds.amazonaws.com:5432/test')

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
    expect { system('RACK_ENV="test" ./app.rb -p UP32EA7196') }
      .to output(/Car successfully parked at \d!!/).to_stdout_from_any_process
  end

  it 'should unpark a parked car and generate invoice' do
    system('RACK_ENV="test" ./app.rb -p UP32EA7196')
    expect { system('echo | RACK_ENV="test" ./app.rb -u UP32EA7196') }
      .to output(
        %r{Car parked at \d
Do you want to unpark it\? \(Y/n\)

Invoice Details:
Invoice number: (\d*)
Registration Number: (\d*)
Entry Time: ([\d:+ -]*)
Exit Time: ([\d:+ -]*)
Duration: (\d*)
Amount: (\d*)
}
      ).to_stdout_from_any_process
  end

  it 'list all the cars in the parking lot' do
    expect { system('RACK_ENV="test" ./app.rb --all-cars') }
      .to output(
        /Car ID\tRegistration Number\tEntry Time
((\d*) [A-Za-z]{2}[a-zA-Z0-9]{8} ([\d:+ -]*))*/
      ).to_stdout_from_any_process
  end
end

RSpec.describe 'Invoice' do
  it 'display the invoice details' do
    system('RACK_ENV="test" ./app.rb -p UP32EA7196')
    response = `echo | RACK_ENV="test" ./app.rb -u UP32EA7196`
    invoice_id = response.scan(/\d+/)[1].to_i
    expect { system("RACK_ENV=\"test\" ./app.rb -i #{invoice_id}") }
      .to output(
        /Invoice Details:
Invoice number: (\d*)
Registration Number: [A-Za-z]{2}[a-zA-Z0-9]{8}
Entry Time: ([\d:+ -]*)
Exit Time: ([\d:+ -]*)
Duration: (\d*)
Amount: (\d*)/
      ).to_stdout_from_any_process
  end

  it 'list all the invoices' do
    expect { system('RACK_ENV="test" ./app.rb --all-invoices') }
      .to output(
        /Invoice number\tRegistration Number\tEntry Time\t\t\tExit Time\t\t\tDuration\tAmount
((\d*) [A-Za-z]{2}[a-zA-Z0-9]{8} ([\d:+ -]*) ([\d:+ -]*) (\d*) (\d*))*/
      ).to_stdout_from_any_process
  end
end
