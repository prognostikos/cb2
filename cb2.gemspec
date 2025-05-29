Gem::Specification.new do |s|
  s.name = "cb2"
  s.email = "matt@prognostikos.com"
  s.version = "1.0.0"
  s.license = "MIT"
  s.summary = "Circuit breaker"
  s.description = "Implementation of the circuit breaker pattern in Ruby"
  s.authors = ["Pedro Belo", "Matt Rohrer"]
  s.homepage = "http://github.com/prognostikos/cb2"

  s.files = Dir["lib/**/*.rb"] + Dir["Gemfile*"] + ["README.md"]
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 3.2"

  s.add_dependency "redis", ">= 4", "< 6"
  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rr", "~> 1.1"
  s.add_development_dependency "rspec", "~> 3.1"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "timecop", "~> 0.9"
  s.add_development_dependency "mutex_m", "~> 0.2"
end
