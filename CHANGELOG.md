# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Possible headings are: *Added*, *Changed*, *Deprecated*, *Removed*, *Fixed*, *Security*.

## [Unreleased]

## [0.4.2] - 2024.08.07

### Added

- Added 1Password integration to CLI tool. Use one-password as secrets repository to store and retrieve signing keys with 1Password

### Changed

- Return null instead of [] for JSON output if a view request does not find a resource

## [0.4.1] - 2024.08.02

### Changed

- If nothing was found for a view request the connector CLI now returns "No result found" or an empty JSON array and exit code 0

## [0.4.0] - 2024-07-30

### Added

- New release asset: AWS Lambda function for integration with AWS API Gateway

### Changed

- Sandbox is now treated like a blockchain and not a separate setting
