require 'securerandom'

class CB2::RollingWindow
  attr_accessor :service, :duration, :threshold, :reenable_after, :redis

  def initialize(options)
    @service        = options.fetch(:service)
    @duration       = options.fetch(:duration)
    @threshold      = options.fetch(:threshold)
    @reenable_after = options.fetch(:reenable_after)
    @redis          = options[:redis] || Redis.new
  end

  def open?
    @last_open = nil # always fetch the latest value from redis here
    last_open && last_open.to_i > (Time.now.to_i - reenable_after)
  end

  def half_open?
    last_open && last_open.to_i < (Time.now.to_i - reenable_after)
  end

  def last_open
    @last_open ||= redis.get(key)
  end

  def success
    if half_open?
      reset!
    end
  end

  def error
    count = increment_rolling_window(key("error"))
    if half_open? || should_open?(count)
      trip!
    end
  end

  def reset!
    @last_open = nil
    redis.del(key)
  end

  def trip!
    @last_open = Time.now.to_i
    redis.set(key, @last_open.to_s)
  end

  # generate a key to use in redis
  def key(id=nil)
    postfix = id ? "-#{id}" : ""
    "cb2-#{service}#{postfix}"
  end

  protected

  def increment_rolling_window(key)
    t   = Time.now.to_i
    pipeline = redis.pipelined do |pipeline|
      # keep the sorted set clean
      pipeline.zremrangebyscore(key, "-inf", (t - duration).to_s)
      # add as a random uuid because sorted sets won't take duplicate items:
      pipeline.zadd(key, t, SecureRandom.uuid)
      # just count how many errors are left in the set
      pipeline.zcard(key)
    end
    return pipeline.last # return the count
  end

  def should_open?(error_count)
    error_count >= threshold
  end
end
