Gem::Specification.new do |s|
  s.name = "cb2"
  s.email = "matt@prognostikos.com"
  s.version = "0.0.4"
  s.license = "MIT"
  s.summary = "Circuit breaker"
  s.description = "Implementation of the circuit breaker pattern in Ruby"
  s.authors = ["Pedro Belo", "Matt Rohrer"]
  s.homepage = "http://github.com/prognostikos/cb2"

  s.files = Dir["lib/**/*.rb"] + Dir["Gemfile*"]
  s.require_paths = ["lib"]

  s.add_dependency "redis", "~> 5", ">= 4"
  s.add_development_dependency "rake", "> 0"
  s.add_development_dependency "rr", "~> 1.1"
  s.add_development_dependency "rspec", "~> 3.1"
  s.add_development_dependency "minitest", "> 0"
  s.add_development_dependency "timecop", "> 0"
end
