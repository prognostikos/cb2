require "redis"

module CB2
end

require "cb2/breaker"
require "cb2/error"
require "cb2/strategies/rolling_window"
require "cb2/strategies/percentage"
require "cb2/strategies/stub"
