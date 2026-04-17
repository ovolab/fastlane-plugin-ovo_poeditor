# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.1] - 2026-04-17

### Fixed

- Normalized Apple `.strings` values to strip escaped double newlines (`\\n`)

## [1.2.0] - 2026-03-03

### Added

- Added `bypass_default_language` parameter to skip the default language check

## [1.1.0] - 2026-01-18

### Added

- Added `default_language` and `language_map` options to better support Android
- Added `unquoted_strings` flag when triggering `android_strings`

### Changed

- Updated available options description
- Updated Ruby requirement to version 3.0
- Removed language map from environment variables in favor of the new option

### Fixed

- Removed stray `form_data` debug print

## [1.0.0] - 2025-08-06

### Added

- First public release of the `ovo_poeditor` fastlane plugin
- Added `.lproj` handling for Apple `.strings` export

### Changed

- Do not block fastlane execution on error
