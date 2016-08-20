require "spec_helper"

class CustomStrategy
  attr_accessor :initialized

  def initialize(options)
    @initialized = true
  end

  def open?
  end
end

describe CB2::Breaker do
  let(:breaker) do

  end

  describe "#initialize" do
    it "initializes the strategy" do
      breaker = CB2::Breaker.new(
          strategy:  CustomStrategy,
          duration:  60,
          threshold: 10,
          reenable_after: 600)
      assert breaker.strategy.is_a?(CustomStrategy)
      assert breaker.strategy.initialized
    end
  end
end
