require "cb2/strategies/base"

module CB2
  class Stub < Strategies::Base
    attr_accessor :allow

    def initialize(options)
      @allow = options.fetch(:allow)
    end

    def open?
      !allow
    end
  end
end
