# frozen_string_literal: true

require 'time'
require 'sequel'

DATABASE = Sequel.connect('postgres://localhost:5432/development')

require_relative './model/car'
require_relative './model/invoice'
require_relative './model/slot'
require_relative './controller/initialize_app'
require_relative './controller/invoice'
require_relative './controller/park'
require_relative './controller/unpark'

# module for menu-driven app
module App
  def self.print_menu
    puts "Choose an option from the below list
1. Park Car
2. Find and unpark Car
3. Get Invoice
4. View all invoices
5. View all parked cars
0. Exit app"
  end

  def self.print_invoice(invoice)
    puts "
Invoice Details:
Invoice number: #{invoice[:id]}
Registration Number: #{invoice[:car_id]}
Entry Time: #{invoice[:entry_time]}
Exit Time: #{invoice[:exit_time]}
Duration: #{invoice[:duration]}
Amount: #{invoice[:invoice_amount]}
         "
  end

  def self.park_car
    puts 'Enter car registration number'
    slot = ParkingLot.park_car(gets)

    if slot.instance_of?(Integer)
      puts "Car successfully parked at #{slot}!!"
    else
      puts slot
    end
  end

  def self.unpark_car
    puts 'Enter car registration number'
    slot_no = ParkingLot.get_slot_no(gets)
    puts "car parked at #{slot_no}"
    puts 'Do you want to unpark it? (Y/n)'

    return if gets == 'n'

    print_invoice(ParkingLot.unpark_car(slot_no))
  end

  def self.invoice
    puts 'Enter invoice number'

    print_invoice(ParkingLot.invoice(gets))
  end

  def self.print_all_invoices
    invoices = ParkingLot.all_invoices
    puts "Invoice number\tRegistration Number\tEntry Time\tExit Time\tDuration\tAmount"
    invoices.each do |invoice|
      puts "#{invoice[:id]}\t#{invoice[:car_id]}\t#{invoice[:entry_time]}\t#{invoice[:exit_time]}\t#{invoice[:duration]}\t#{invoice[:invoice_amount]}"
    end
  end

  def self.print_all_parked_cars
    cars = ParkingLot.all_parked_cars
    puts "Car ID\tRegistration Number\tEntry Time"
    cars.each do |car|
      puts "#{car[:id]}\t#{car[:registration_number]}\t#{car[:entry_time]}"
    end
  end
end

ParkingLot.initialize_app

loop do
  App.print_menu
  line = gets
  case line.to_i
  when 1
    App.park_car
  when 2
    App.unpark_car
  when 3
    App.invoice
  when 4
    App.print_all_invoices
  when 5
    App.print_all_parked_cars
  else
    break
  end
end
