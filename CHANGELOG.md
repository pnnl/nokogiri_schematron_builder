# Changelog

All notable changes to this project will be documented in this file.

## [0.1.2] - 2021-08-30

### Changed
- Upgrade `bundler` and `rake` dependencies.

## [0.1.1] - 2019-11-07

### Added
- This `CHANGELOG.md` file.

### Changed
- Rename attribute from `Nokogiri::XML::Schematron::Pattern#name` to `Nokogiri::XML::Schematron::Pattern#title`.
- Map `Nokogiri::XML::Schematron::Pattern#title` attribute to `<sch:title>` XML element (previously `@name` XML attribute).
- Map `Nokogiri::XML::Schematron::Schema#title` attribute to `<sch:title>` XML element (previously, `@title` XML attribute).

## [0.1.0] - 2019-10-20

### Added
- Initial commit.
