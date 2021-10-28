require "bundler/setup"

Bundler.setup

require "timecop"
require "cb2"
require 'rspec'

# establish a Redis connection to the default server (localhost:6379)
Redis.new

RSpec.configure do |config|
  config.expect_with :minitest

  config.before(:each) do
    redis.flushdb
  end

  config.filter_run focus: true

  config.run_all_when_everything_filtered = true

  def redis
    @redis ||= Redis.current
  end
end
