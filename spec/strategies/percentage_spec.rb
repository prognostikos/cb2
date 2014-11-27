require "spec_helper"

describe CB2::RollingWindow do
  let(:breaker) do
    CB2::Breaker.new(
      strategy:  :percentage,
      duration:  60,
      threshold: 10,
      reenable_after: 600)
  end

  let(:strategy) { breaker.strategy }

  describe "#open?" do
    it "starts closed" do
      refute breaker.open?
    end

    it "checks in redis" do
      redis.set(strategy.key, 1)
      assert breaker.open?
    end
  end

  describe "#open!" do
    it "sets a key in redis with corresponding expiration" do
      strategy.open!
      assert_equal 600, redis.ttl(strategy.key)
    end
  end

  describe "#error" do
    before { @t = Time.now }

    it "opens the circuit when we hit the threshold percentage" do
      5.times { strategy.count }
      strategy.error
      assert breaker.open?
    end
  end
end
