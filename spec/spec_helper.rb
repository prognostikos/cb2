require "bundler/setup"

Bundler.setup

require "timecop"
require "cb2"

require 'redis'

# establish a Redis connection to the default server (localhost:6379)
require 'cb2/backends/redis'
CB2.backend = CB2::Backends::Redis.new(:redis => Redis.new)

RSpec.configure do |config|
  config.expect_with :minitest
  config.mock_with :rr

  config.before(:each) do
    redis.flushdb
  end

  def redis
    @redis ||= Redis.current
  end
end
