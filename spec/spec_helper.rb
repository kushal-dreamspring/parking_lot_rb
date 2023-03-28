# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:each) do |example|
    DATABASE.transaction(rollback: :always, auto_savepoint: true) { example.run }
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
