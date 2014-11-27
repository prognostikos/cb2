require "spec_helper"

describe CB2 do
  let(:breaker) do
    CB2::Breaker.new(
      strategy: :stub,
      allow:    false)
  end

  it "raises when the breaker is open" do
    assert_raises(CB2::BreakerOpen) do
      breaker.run { 1+1 }
    end
  end
end
