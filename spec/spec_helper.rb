require "bundler/setup"

Bundler.setup

require "timecop"
require "cb2"

RSpec.configure do |config|
  config.expect_with :minitest
  config.mock_with :rr

  config.before(:each) do
    redis.flushdb
  end

  def redis
    @redis ||= Redis.new
  end
end
