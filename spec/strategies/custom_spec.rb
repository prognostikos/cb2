require "spec_helper"

class CustomStrategy < CB2::Percentage

end

describe CB2::Percentage do
  let(:breaker) do

  end

  describe "#initialize" do
    it "initializes the strategy" do
      breaker = CB2::Breaker.new(
          strategy:  CustomStrategy,
          duration:  60,
          threshold: 10,
          reenable_after: 600)
      assert breaker.strategy
    end
  end
end
