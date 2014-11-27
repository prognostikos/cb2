# CB2

Implementation of the [circuit breaker pattern](http://martinfowler.com/bliki/CircuitBreaker.html) in Ruby, backed by Redis.

The basic idea is to add circuit breakers around external service calls. When one of these services becomes unavailable the circuit breaker opens, causing additional requests to it to fail fast. After a specific window of time the breaker closes again, allowing requests to that service to go through.

This benefits both sides:

- Your application becomes more resilient to third party failures, because it won't exhaust resources trying to make calls to an unresponsive service. This is particularly relevant to apps running on servers susceptible to request queuing, like Unicorn or Puma.

- External services having availability issues will stop receiving calls, which could otherwise make the issues worse.


## Usage

Instantiate a circuit breaker:

```ruby
breaker = CB2::Breaker.new(
  duration: 60,        # keep track of errors over a 1min window
  threshold: 5,        # open the circuit breaker on 5 errors
  reenable_after: 600) # keep it open for 10mins
```

Then encapsulate your API calls through it:

```ruby
breaker.run { some_api_request() }
```
