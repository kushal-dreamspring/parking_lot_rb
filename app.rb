#!/usr/bin/env ruby

# frozen_string_literal: true

require 'time'
require 'sequel'
require 'optparse'

DATABASE = Sequel.connect(
  "postgres://postgres:7dgA7ycUvtPxVm4@parking-lot.cmwearec5mjd.ap-south-1.rds.amazonaws.com:5432/#{
ENV['RACK_ENV'] || 'development'
}"
)

require_relative './model/car'
require_relative './model/invoice'
require_relative './model/slot'
require_relative './controller/initialize_app'
require_relative './controller/invoice'
require_relative './controller/park'
require_relative './controller/unpark'
require_relative './controller/all_cars'

# module for menu-driven app
module App
  def self.print_invoice(invoice)
    puts "
Invoice Details:
Invoice number: #{invoice[:id]}
Registration Number: #{invoice[:registration_number]}
Entry Time: #{invoice[:entry_time]}
Exit Time: #{invoice[:exit_time]}
Duration: #{invoice[:duration]}
Amount: #{invoice[:invoice_amount]}"
  end

  def self.find_and_unpark_car(registration_number)
    slot_no = ParkingLot.get_slot_no(registration_number)

    if slot_no
      puts "Car parked at #{slot_no}"
      puts 'Do you want to unpark it? (Y/n)'

      return if gets == 'n'

      print_invoice(ParkingLot.unpark_car(slot_no))
    else
      puts 'car not found'
    end
  end

  def self.print_all_invoices
    invoices = ParkingLot.all_invoices
    puts "Invoice number\tRegistration Number\tEntry Time\t\t\tExit Time\t\t\tDuration\tAmount"
    invoices.each do |invoice|
      puts "#{invoice[:id]}\t\t#{invoice[:registration_number]}\t\t#{invoice[:entry_time]}\t#{invoice[:exit_time]}\t#{invoice[:duration]}\t\t#{invoice[:invoice_amount]}"
    end
  end

  def self.print_all_parked_cars
    cars = ParkingLot.all_parked_cars
    puts "Car ID\tRegistration Number\tEntry Time"
    cars.each do |car|
      puts "#{car[:id]}\t#{car[:registration_number]}\t\t#{car[:entry_time]}"
    end
  end
end

ParkingLot.initialize_app

parser = OptionParser.new
parser.banner

parser.on('') do
  puts "Error: No option specified\nUsage: app [options]\nEnter 'app.rb --help' for options list"
end
parser.on('-p [REG_NO]', '--park', 'Park Car [Registration Number]') do |registration_number|
  ParkingLot.park_car(registration_number)
end
parser.on('-u [REG_NO]', '--unpark', 'Find and Unpark Car [Registration Number]') do |registration_number|
  App.find_and_unpark_car(registration_number)
end
parser.on('-i [INV_NO]', '--invoice', 'Get Invoice  [Invoice Number]') do |invoice_number|
  App.print_invoice(ParkingLot.invoice(invoice_number))
end
parser.on('--all-invoices', 'Get All Invoices') { App.print_all_invoices }
parser.on('--all-cars', 'Get All Cars') { App.print_all_parked_cars }
parser.on('-r', '--reset', 'Reset App') { ParkingLot.reset_db }
parser.on('-h', '--help', 'List all options') { puts parser }

parser.parse!
