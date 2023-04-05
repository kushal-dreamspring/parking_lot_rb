# Parking Lot App

A Parking Lot management app made with Ruby

### Usage

#### Park Car
`` ./app.rb -p [registration_number] ``

#### Find and Unpark Car
`` ./app.rb -u [registration_number] ``

#### Get Invoice
`` ./app.rb -i [invoice_number] ``

#### Get all Invoices
`` ./app.rb --all-invoices ``

#### Get All Parked Cars
`` ./app.rb --all-cars ``

#### Reset Database
`` ./app.rb -r ``

#### List All Options
`` ./app.rb -h ``

### Local Setup

#### Install gems
`` bundle install ``

#### Run database migrations

`` sequel -m ./migrations postgres://host:port/database_name ``