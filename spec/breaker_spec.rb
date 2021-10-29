require "spec_helper"

describe CB2::Breaker do
  let(:breaker_strategy) { double("Breaker Strategy") } 
  let(:breaker) do
    CB2::Breaker.new(
      strategy: :stub,
      allow:    false)
  end

  describe "#run" do
    it "raises when the breaker is open" do
      assert_raises(CB2::BreakerOpen) do
        breaker.run { 1+1 }
      end
    end

    it "returns the original value" do
      breaker.strategy.allow = true
      assert_equal 42, breaker.run { 42 }
    end
  end

  describe "#open?" do
    it "delegates to the strategy" do
      assert breaker.open?
    end

    it "handles Redis errors, just consider the circuit closed" do
      allow_any_instance_of(CB2::Breaker).to receive(:strategy).and_return(breaker_strategy)
      allow(breaker_strategy).to receive(:open?).and_raise(Redis::BaseError)
      refute breaker.open?
    end
  end
end
