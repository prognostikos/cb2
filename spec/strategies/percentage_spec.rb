require "spec_helper"

describe CB2::Percentage do
  subject(:breaker) do
    CB2::Breaker.new(
      strategy:  :percentage,
      duration:  60,
      threshold: 10,
      reenable_after: 600)
  end

  let(:strategy) { breaker.strategy }

  describe "#error" do
    before { strategy.reset_all! }

    context 'when we have not received the minimum number of requests' do
      before do
        4.times { strategy.count }
      end

      it 'passes errors up to the application' do
        assert_raises(RuntimeError) { breaker.run { raise 'error' } }
      end
    end

    context 'when we have received the minimum number of requests' do
      before do
        5.times { strategy.count }
      end

      context 'and we make a successful request' do
        before { breaker.run { "Hello" } }

        it 'leaves the breaker closed' do
          assert !breaker.open?
        end
      end

      context 'when we hit the threshold error percentage' do
        before { strategy.error }

        it 'opens the breaker' do
          assert breaker.open?
        end

        it 'intercepts the original error and raises CB2::BreakerOpen instead' do
          assert_raises(CB2::BreakerOpen) { breaker.run { raise 'error' } }
        end

        context 'and then fully reset the breaker' do
          before(:each) { strategy.reset_all! }

          it 'closes the breaker' do
            assert !breaker.open?
          end

          it 'resets the minimum request counter' do
            5.times { strategy.count }
            assert !breaker.open?

            strategy.error
            assert breaker.open?
          end
        end
      end
    end
  end
end
