# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.5] - 2025-08-28

### Added

Nothing

### Changed

Nothing

### Deprecated

Nothing

### Removed

Nothing

### Fixed

- IBEXUS Connector local file storage

### Security

Nothing

## [2.0.4] - 2025-08-15

### Added

- Import designs in the web app

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

## [2.0.3] - 2025-07-28

### Added

Nothing

### Changed

Nothing

### Deprecated

Nothing

### Removed

Nothing

### Fixed

- changes to business engine authorisation to make mandate/role handling more flexible and intuitive

### Security

Nothing

## [2.0.2] - 2025-07-08

### Added

Nothing

### Changed

- The path of the docs of the Ibexus Connector changed from /api-docs to /docs
- The integrated API explorer was switched from RapiDoc to Swagger

### Deprecated

Nothing

### Removed

Nothing

### Fixed

- File permission issues for local storage in IBEXUS Connector image

### Security

Nothing

## [2.0.1] - 2025-06-26

### Added

Nothing

### Changed

- the user of the IBEXUS Connector container image is now specified using the user id instead of the name. This enables some Kubernetes environments to determine whether the user running in the container is root (it is not).

### Deprecated

Nothing

### Removed

Nothing

### Fixed

Nothing

### Security

Nothing

## [2.0.0] - 2025-06-13

### Added

- The latest addition to our products is the IBEXUS Tracker, an IOT device for adding trusted physical sensor data to your processes
- IBEXUS Connector now supports Azure Key Vault as secrets storage

### Changed

- naming of the data type boolean in the field data types was changed to bool from boolean. Please adapt your designs accordingly.
- the step key in the ExecuteProcess message was moved into the action type. Please adapt your designs accordingly.

### Deprecated

Nothing

### Removed

Nothing

### Fixed

Nothing

### Security

Nothing

## [1.0.1] - 2024-12-20

### Added

Nothing

### Changed

- Executing a process and referencing the wrong step will cause an immediate error response. With the IBEXUS Connector REST API it will be a http 400 BAD REQUEST error.

### Deprecated

Nothing

### Removed

Nothing

### Fixed

Nothing

### Security

Nothing

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
