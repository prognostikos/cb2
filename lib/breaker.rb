class CB2::Breaker
  attr_accessor :service, :strategy

  def initialize(options)
    @service  = options[:service] || "default"
    @strategy = CB2::Stub.new(options)
  end

  def run
    if open?
      raise CB2::Error
    end

    begin
      yield
    rescue => e
      strategy.process(e)
      raise e
    end
  end

  def open?
    strategy.open?
  end
end
