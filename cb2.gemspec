Gem::Specification.new do |s|
  s.name = "cb2"
  s.email = "pedrobelo@gmail.com"
  s.version = "0.0.4"
  s.summary = "Circuit breaker"
  s.description = "Implementation of the circuit breaker pattern in Ruby"
  s.authors = ["Pedro Belo"]
  s.homepage = "http://github.com/Codefied/cb2"

  s.files = Dir["lib/**/*.rb"] + Dir["Gemfile*"]
  s.require_paths = ["lib"]

  s.add_dependency "redis", ">= 3.1"
  s.add_development_dependency "rake",    "> 0"
  s.add_development_dependency "rr",      "~> 1.1"
  s.add_development_dependency "rspec",   "~> 3.1"
  s.add_development_dependency "timecop", "~> 0.7"
  s.add_development_dependency "minitest", "~> 5.13.0"
end
