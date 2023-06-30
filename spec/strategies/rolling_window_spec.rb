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
      refute strategy.open?
    end

    it "checks in redis" do
      redis.set(strategy.key, Time.now.to_i)
      assert strategy.open?
    end

    it "closes again after the specified window" do
      redis.set(strategy.key, Time.now.to_i - 601)
      refute strategy.open?
    end
  end

  describe "#half_open?" do
    it "indicates the circuit was opened, but is ready to enable calls again" do
      redis.set(strategy.key, Time.now.to_i - 601)
      assert strategy.half_open?
    end

    it "is not half_open when the circuit is just open (before time reenable_after time)" do
      redis.set(strategy.key, Time.now.to_i - 599)
      refute strategy.half_open?
    end
  end

  describe "#trip!" do
    it "sets a key in redis with the time the circuit was opened" do
      t = Time.now
      Timecop.freeze(t) { strategy.trip! }
      assert_equal t.to_i, redis.get(strategy.key).to_i
    end
  end

  describe "#success" do
    it "resets the counter so half open breakers go back to closed" do
      redis.set(strategy.key, Time.now.to_i - 601)
      strategy.success
      assert_nil redis.get(strategy.key)
    end
  end

  describe "#error" do
    before { @t = Time.now }

    it "opens the circuit when we hit the threshold" do
      5.times { strategy.error }
      assert strategy.open?
    end

    it "opens the circuit right away when half open" do
      redis.set(strategy.key, Time.now.to_i - 601) # set as half open
      strategy.error
      assert strategy.open?
    end

    it "trims the window" do
      Timecop.freeze(@t-60) do
        4.times { strategy.error }
      end
      Timecop.freeze do
        strategy.error
        refute strategy.open?
      end
    end
  end
end
