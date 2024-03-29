# frozen_string_literal: true

require 'rspec'
require 'sequel'
require 'time'

DATABASE = Sequel.connect('sqlite://db/test.sqlite')

RSpec.configure do |config|
  config.around(:each) do |example|
    example.run
    DATABASE[:slots].exclude(car_id: nil).update(car_id: nil, entry_time: nil)
    DATABASE[:invoices].delete
    DATABASE[:cars].delete
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.warnings = false

  config.profile_examples = 10

  config.order = :random

  config.filter_gems_from_backtrace 'sequel'
end
