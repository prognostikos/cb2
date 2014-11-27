require "spec_helper"

describe CB2::RollingWindow do
  let(:breaker) do
    CB2::Breaker.new(
      strategy:  :rolling_window,
      duration:  60,
      threshold: 5,
      reenable_after: 600)
  end

  let(:strategy) { breaker.strategy }

  describe "#open?" do
    it "starts closed" do
      refute breaker.open?
    end

    it "checks in redis" do
      redis.set("circuit-breaker-default", 1)
      assert breaker.open?
    end
  end

  describe "#open!" do
    it "sets a key in redis with corresponding expiration" do
      strategy.open!
      assert_equal 600, redis.ttl("circuit-breaker-default")
    end
  end

  describe "#process" do
    before { @t = Time.now }

    it "opens the circuit when we hit the threshold" do
      5.times { strategy.process }
      assert breaker.open?
    end

    it "trims the window" do
      Timecop.freeze(@t-60) do
        4.times { strategy.process }
      end
      Timecop.freeze do
        strategy.process
        refute breaker.open?
      end
    end
  end
end
