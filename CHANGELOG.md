# Changelog

## Unreleased

### Fixed

- fix gem build warnings by adding version constraints and a required_ruby_version

## 1.0.0

### Added

- support for 4.x version of redis gem

### Removed

- testing on non-supported rubies

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
