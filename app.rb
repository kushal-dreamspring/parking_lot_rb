#!/usr/bin/env ruby

# frozen_string_literal: true

require 'time'
require 'sequel'
require 'optparse'

DB_URL = if ENV['RACK_ENV'] == 'test'
           'sqlite://db/test.sqlite'
         else
           'postgres://postgres:7dgA7ycUvtPxVm4@exercisedb.cmwearec5mjd.ap-south-1.rds.amazonaws.com:5432/development'
         end

DATABASE = Sequel.connect(DB_URL)

require_relative './model/car'
require_relative './model/invoice'
require_relative './model/slot'
require_relative './controller/initialize_app'
require_relative './controller/invoice'
require_relative './controller/park'
require_relative './controller/unpark'
require_relative './controller/all_cars'

# module for menu-driven app
class App
  def initialize
    @controller = Controller.new
    @parser = OptionParser.new
    parser_options

    @parser.banner
    @parser.parse!
  end

  def parser_options
    @parser.on('-p [REG_NO]', '--park', 'Park Car [Registration Number]') do |registration_number|
      @controller.park_car(registration_number)
    end
    @parser.on('-u [REG_NO]', '--unpark', 'Find and Unpark Car [Registration Number]') do |registration_number|
      find_and_unpark_car(registration_number)
    end
    @parser.on('-i [INV_NO]', '--invoice', 'Get Invoice  [Invoice Number]') do |invoice_number|
      print_invoice(@controller.invoice(invoice_number))
    end
    @parser.on('--all-invoices', 'Get All Invoices') { print_all_invoices }
    @parser.on('--all-cars', 'Get All Cars') { print_all_parked_cars }
    @parser.on('-r', '--reset', 'Reset App') { @controller.reset_db }
    @parser.on('-h', '--help', 'List all options') { puts @parser }
  end

  def print_invoice(invoice)
    puts "
Invoice Details:
Invoice number: #{invoice[:id]}
Registration Number: #{invoice[:registration_number]}
Entry Time: #{invoice[:entry_time]}
Exit Time: #{invoice[:exit_time]}
Duration: #{invoice[:duration]}
Amount: #{invoice[:invoice_amount]}"
  end

  def find_and_unpark_car(registration_number)
    slot_no = @controller.get_slot_no registration_number

    if slot_no
      puts "Car parked at #{slot_no}"
      puts 'Do you want to unpark it? (Y/n)'

      return if gets == "n\n"

      print_invoice(@controller.unpark_car(slot_no))
    else
      puts 'car not found'
    end
  end

  def print_all_invoices
    invoices = @controller.all_invoices
    if invoices.empty?
      puts 'No Invoice Found'
    else
      puts "Invoice number\tRegistration Number\tEntry Time\t\t\tExit Time\t\t\tDuration\tAmount"
      invoices.each do |invoice|
        puts "#{invoice[:id]}\t\t#{invoice[:registration_number]}\t\t#{invoice[:entry_time]}\t#{invoice[:exit_time]}\t#{invoice[:duration]}\t\t#{invoice[:invoice_amount]}"
      end
    end
  end

  def print_all_parked_cars
    cars = @controller.all_parked_cars

    if cars.empty?
      puts 'No Car Found'
    else
      puts "Slot ID\tRegistration Number\tEntry Time"
      cars.each do |car|
        puts "#{car[:id]}\t#{car[:registration_number]}\t\t#{car[:entry_time]}"
      end
    end
  end
end

App.new
