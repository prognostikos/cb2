# Changelog

## 0.0.4

### Added

- CI using GitHub Actions for non-eol Ruby versions
- add an exception message to BreakerOpen exception with the service name

### Fixed

- replaced deprecated usage of `Redis.current`
- replaced deprecated usage of `redis.pipelined`
- replaced deprecated usage of `assert_equal nil`

### Changed

- Upgraded development dependencies
- Upgraded to latest 5.x Redis gem
