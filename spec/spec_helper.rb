require "bundler/setup"
require "hilight"

RSpec::Matchers.alias_matcher :return_a_kind_of, :be_a_kind_of
RSpec::Matchers.alias_matcher :return_nil, :be_nil
RSpec::Matchers.alias_matcher :return_falsey, :be_falsey
RSpec::Matchers.alias_matcher :return_truthy, :be_truthy


RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
end
