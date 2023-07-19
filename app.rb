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

require_relative './controller/slot_controller'
require_relative './controller/invoice_controller'

# module for menu-driven app
class App
  def initialize
    @slot_controller = SlotController.new
    @invoice_controller = InvoiceController.new
    @parser = OptionParser.new
    parser_options

    @parser.banner
    @parser.parse!
  end

  def parser_options
    @parser.on('-p [REG_NO]', '--park', 'Park Car [Registration Number]') do |registration_number|
      @slot_controller.park_car(registration_number)
    end
    @parser.on('-u [REG_NO]', '--unpark', 'Find and Unpark Car [Registration Number]') do |registration_number|
      @slot_controller.find_and_unpark_car(registration_number)
    end
    @parser.on('-i [INV_NO]', '--invoice', 'Get Invoice  [Invoice Number]') do |invoice_id|
      @invoice_controller.invoice(invoice_id)
    end
    @parser.on('--all-invoices', 'Get All Invoices') { @invoice_controller.all_invoices }
    @parser.on('--all-cars', 'Get All Cars') { @slot_controller.all_parked_cars }
    @parser.on('-r', '--reset', 'Reset App') { @slot_controller.reset_db }
    @parser.on('-h', '--help', 'List all options') { puts @parser }
  end
end

App.new
