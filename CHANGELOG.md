# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 13.06.2025

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
