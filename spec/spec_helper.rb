require "bundler/setup"

Bundler.setup

require "timecop"
require "rr"
require "cb2"

# establish a Redis connection to the default server (localhost:6379)
Redis.new

RSpec.configure do |config|
  config.expect_with :minitest
  config.include RR::DSL

  config.before(:each) do
    redis.flushdb
  end

  def redis
    @redis ||= Redis.new
  end
end
