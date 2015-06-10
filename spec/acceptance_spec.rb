require "spec_helper"

describe "Acceptance" do
  let(:breaker) do
    CB2::Breaker.new(
      strategy:  :percentage,
      duration:  10,
      threshold: 9,
      reenable_after: 5)
  end

  def fail!
    breaker.run { raise SocketError }
  rescue SocketError
  end

  def pass!
    breaker.run { true }
  end

  it "toggles states" do
    t = Time.now

    # starting with a fresh closed circuit
    Timecop.freeze(t) do
      9.times { pass! }
      fail!
      assert breaker.open?
      assert_raises(CB2::BreakerOpen) { fail! }
    end

    # circuit should now be half-open, make sure it closes on a single success
    Timecop.freeze(t += 6) do
      pass!
      refute breaker.open?
    end

    # close it again
    Timecop.freeze(t) do
      9.times { pass! }
      fail!
      assert breaker.open?
    end

    # half open again, make sure it opens on a single failure
    Timecop.freeze(t += 6) do
      fail!
      assert breaker.open?
    end
  end
end
