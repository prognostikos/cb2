require "spec_helper"

describe CB2::Breaker do
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
  end

  describe "#open?" do
    it "delegates to the strategy" do
      assert breaker.open?
    end

    it "handles Redis errors, just consider the circuit closed" do
      stub(breaker.strategy).open? { raise Redis::BaseError }
      refute breaker.open?
    end
  end
end
