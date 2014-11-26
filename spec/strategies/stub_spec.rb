require "spec_helper"

describe CB2::Stub do
  describe "default behavior (allow all)" do
    before { @breaker = CB2::Breaker.new(allow: true) }

    it "always leave the breaker closed, allowing all calls" do
      refute @breaker.open?
    end
  end

  describe "when disabled" do
    before { @breaker = CB2::Breaker.new(allow: false) }

    it "always leaves the breaker open, denying all calls" do
      assert @breaker.open?
    end
  end
end
