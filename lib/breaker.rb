class CB2::Breaker
  attr_accessor :service, :strategy

  def initialize(options)
    @service  = options[:service] || "default"
    @strategy = initialize_strategy(options)
  end

  def run
    if open?
      raise CB2::BreakerOpen
    end

    begin
      yield
    rescue => e
      strategy.process
      raise e
    end
  end

  def open?
    strategy.open?
  end

  def initialize_strategy(options)
    strategy_options = options.dup.merge(service: self.service)

    if options[:strategy].respond_to?(:open)
      return options[:strategy].new(strategy_options)
    end

    case options[:strategy].to_s
    when "", "rolling_window"
      CB2::RollingWindow.new(strategy_options)
    when "stub"
      CB2::Stub.new(strategy_options)
    end
  end
end
