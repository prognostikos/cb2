class CB2::Stub
  attr_accessor :allow

  def initialize(options)
    @allow = options.fetch(:allow)
  end

  def open?
    !allow
  end

  def process(e)
  end
end
