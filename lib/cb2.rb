module CB2
  def self.backend=(backend)
    @backend = backend
  end

  def self.backend
    @backend
  end
end

require "cb2/breaker"
require "cb2/error"
require "cb2/backends"
require "cb2/strategies/base"
require "cb2/strategies/rolling_window"
require "cb2/strategies/percentage"
require "cb2/strategies/stub"
