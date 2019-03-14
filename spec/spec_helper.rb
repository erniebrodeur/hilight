require "bundler/setup"
require "hilight"

RSpec::Matchers.alias_matcher :return_a_kind_of, :be_a_kind_of
RSpec::Matchers.alias_matcher :return_nil, :be_nil
RSpec::Matchers.alias_matcher :return_falsey, :be_falsey
RSpec::Matchers.alias_matcher :return_truthy, :be_truthy

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
