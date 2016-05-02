require "redis"

module CB2::Backends
  class Redis
    attr_reader :redis

    def initialize(options = {})
      @redis = options[:redis] || Redis.current
    end

    def delete(key)
      catch_redis { redis.del(key) }
    end

    def set(key, val)
      catch_redis { redis.set(key, val) }
    end

    def get(key)
      catch_redis { redis.get(key) }
    end

    def count(key)
      catch_redis { redis.zcard(key) }
    end

    def remove_range(key, min, max)
      min = "-inf" if min.nil?
      catch_redis { redis.zremrangebyscore(key, min, max) }
    end

    def add_to_weighted_set(key, weight, val)
      catch_redis { redis.zadd(key, weight, val) }
    end

    def atomic(&block)
      return_set = catch_redis { redis.pipelined(&block) }
      return_set.last # blocks like this tend to return the last
    end

    private
      def catch_redis
        yield
      rescue Redis::BaseError => e
        raise BackendError, "Redis Connection issues: #{e}"
      end
  end
end
