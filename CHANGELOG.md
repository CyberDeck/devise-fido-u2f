# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.14] - 2021-03-02
### Changed
- Fixed registrations controller to include javascript responses

## [0.1.13] - 2021-03-02
### Changed
- Fixed test cases

## [0.1.12] - 2021-03-02
### Changed
- Merged #14 to call after_sign_in_path_for on successful registration

## [0.1.11] - 2018-12-29
### Changed
- Fixed issues for the test cases where some CDATA are not stripped for the RKelly AST.

## [0.1.10] - 2018-12-28
### Added
- Started a CHANGELOG (this file)

### Changed
- Changed the application layout view templates to not use any 'style' tags to allow for strict content security policy settings
- Changed the application layout view templates to use content security policy nonces for embedded javascript
