module CB2::Strategies
  class Base
    def process(type)
      send(type) if respond_to?(type)
    rescue Backends::BackendError
      nil
    end
  end
end
