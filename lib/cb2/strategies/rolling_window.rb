require "cb2/strategies/base"

class CB2::RollingWindow < CB2::Strategies::Base
  attr_accessor :service, :duration, :threshold, :reenable_after, :backend

  def initialize(options)
    @service        = options.fetch(:service)
    @duration       = options.fetch(:duration)
    @threshold      = options.fetch(:threshold)
    @reenable_after = options.fetch(:reenable_after)
    @backend        = options[:backend] || CB2.backend
  end

  def open?
    @last_open = nil # always fetch the latest value from backend here
    last_open && last_open.to_i > (Time.now.to_i - reenable_after)
  end

  def half_open?
    last_open && last_open.to_i < (Time.now.to_i - reenable_after)
  end

  def last_open
    @last_open ||= backend.get(key)
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
    backend.delete(key)
  end

  def trip!
    @last_open = Time.now.to_i
    backend.set(key, @last_open)
  end

  # generate a key to use in backend
  def key(id=nil)
    postfix = id ? "-#{id}" : ""
    "cb2-#{service}#{postfix}"
  end

  protected

  def increment_rolling_window(key)
    t = Time.now.to_i
    backend.atomic do
      # keep the sorted set clean
      backend.remove_range(key, nil, t - duration)
      # add as a random uuid because sorted sets won't take duplicate items:
      backend.add_to_weighted_set(key, t, SecureRandom.hex(10))
      # just count how many errors are left in the set
      backend.count(key)
    end
  end

  def should_open?(error_count)
    error_count >= threshold
  end
end
