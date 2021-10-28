Gem::Specification.new do |s|
  s.name = "cb2"
  s.email = "pedrobelo@gmail.com"
  s.version = "0.0.3"
  s.summary = "Circuit breaker"
  s.description = "Implementation of the circuit breaker pattern in Ruby"
  s.authors = ["Pedro Belo"]
  s.homepage = "http://github.com/pedro/cb2"

  s.files = Dir["lib/**/*.rb"] + Dir["Gemfile*"]
  s.require_paths = ["lib"]

  s.add_dependency "redis", "~> 4.5"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "minitest"
  s.add_development_dependency "timecop"
end
