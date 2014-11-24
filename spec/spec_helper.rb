require "bundler/setup"

Bundler.setup

require "cb2"

RSpec.configure do |config|
  config.expect_with :minitest
end
