class CB2::RollingWindow
  attr_accessor :service, :duration, :threshold, :reenable_after, :redis

  def initialize(options)
    @service        = options.fetch(:service)
    @duration       = options.fetch(:duration)
    @threshold      = options.fetch(:threshold)
    @reenable_after = options.fetch(:reenable_after)
    @redis          = options[:redis] || Redis.current
  end

  def open?
    redis.exists(key)
  end

  def open!
    redis.setex(key, reenable_after, 1)
  end

  def error
    count = increment_rolling_window(key("error"))
    if should_open?(count)
      open!
    end
  end

  # generate a key to use in redis
  def key(id=nil)
    postfix = id ? "-#{id}" : ""
    "cb2-#{service}#{postfix}"
  end

  protected

  def increment_rolling_window(key)
    t   = Time.now.to_i
    pipeline = redis.pipelined do
      # keep the sorted set clean
      redis.zremrangebyscore(key, "-inf", t - duration)
      # add as a random uuid because sorted sets won't take duplicate items:
      redis.zadd(key, t, SecureRandom.uuid)
      # just count how many errors are left in the set
      redis.zcard(key)
    end
    return pipeline.last # return the count
  end

  def should_open?(error_count)
    error_count >= threshold
  end
end
