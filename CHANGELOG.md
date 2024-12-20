# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1]

### Changed

- Executing a process and referencing the wrong step will cause an immediate error response. With the IBEXUS Connector REST API it will be a http 400 BAD REQUEST error.

## [1.0.0]

### Added

- Payment is now activated. No transactions are possible without credits

### Changed

- Process design: field definitions are now stored in the scope. This is a breaking change. You will need to rework your designs.

## [0.4.2] - 2024-08-07

### Added

- Initial release

### Changed

Nothing

### Deprecated

Nothing

### Removed

Nothing

### Fixed

Nothing

### Security

Nothing
