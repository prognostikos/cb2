# CB2

[![Gem version](http://img.shields.io/gem/v/cb2.svg)](https://rubygems.org/gems/cb2)
[![Build Status](https://travis-ci.org/pedro/cb2.svg?branch=master)](https://travis-ci.org/pedro/cb2)

Implementation of the [circuit breaker pattern](http://martinfowler.com/bliki/CircuitBreaker.html) in Ruby, backed by Redis.

Setup circuit breakers wrapping external service calls, be it HTTP, TCP, etc. When a service becomes unavailable the circuit breaker will open and quickly refuse any additional requests to it. After a specific window the breaker closes again, allowing calls to go through.

This pattern makes your application more resilient to third party failures, because it won't exhaust resources trying to make calls to an unresponsive service. This is particularly relevant to apps running on servers susceptible to request queuing, like Unicorn or Puma. It can also help the services you depend on to recover faster, by reducing the load on them.

CB2 tracks errors over a rolling window of time (size configurable), and opens after the error rate hits a certain percentage. The circuit stays open (rejecting calls) for another specified period, and then from there it goes to the half-open state: in which a succesful request will make it close again, but a failure will put it immediatelly back at the open state. [Martin Fowler has a nice diagram to further explain these states](http://martinfowler.com/bliki/CircuitBreaker.html).


## Usage

Instantiate a circuit breaker:

```ruby
breaker = CB2::Breaker.new(
  service: "aws"       # identify each circuit breaker individually
  duration: 60,        # keep track of errors over a 1 min window
  threshold: 5,        # open the circuit breaker when error rate is at 5%
  reenable_after: 600, # keep it open for 10 mins
  redis: Redis.new)    # redis connection it should use to keep state
```

Then wrap service calls with it:

```ruby
breaker.run do
  some_api_request()
end
```

The breaker will open when that block raises enough exceptions to trigger the threshold. Handle these exceptions to react accordingly:

```ruby
begin
  breaker.run do
    some_api_request()
  end
rescue CB2::BreakerOpen
  alternate_response() # fallback to cached data, or raise a user-friendly exception
end
```

### Configuration

You can provide a `CB2_PREFIX` environment variable to prefix the redis key used by your application.

This prevents conflicts in case multiple applications using CB2 share the same Redis backend

### Circuit breaker stub

CB2 can also run as a stub. Use it to aid testing, simulations and gradual rollouts:

```ruby
breaker = CB2::Breaker.new(
  strategy: "stub",
  allow: true) # set it to false to always block requests
```

## See also

This might be the only percent-based breaker in Ruby so far. For count-based breakers (eg: open after X exceptions) you can also check [breaker_box](https://github.com/sittercity/breaker_box) and [circuit_breaker](https://github.com/wsargent/circuit_breaker).

## Meta

Created by Pedro Belo, enhanced by Westfield Digital
