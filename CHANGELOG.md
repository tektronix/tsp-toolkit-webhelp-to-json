# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
Check [Keep a Changelog](http://keepachangelog.com/) for recommendations on how to structure this file.

    Added -- for new features.
    Changed -- for changes in existing functionality.
    Deprecated -- for soon-to-be removed features.
    Removed -- for now removed features.
    Fixed -- for any bug fixes.
    Security -- in case of vulnerabilities.
-->

## [0.19.1]

### Added
- new module support infrestructure

## [0.18.4]

### Added
- handling dynamically creating enums for trigger.model.setblock() command parameter

### Fixed
- making sure that node[N].execute(), node[N].getglobal() and node[N].setglobal() only visible in TSP-Link systems.

## [0.18.3]

### Added
- support dynamically creating enums for configured nodes

## [0.18.2]

### Added
- Added Lua 5.0 definitions

## [0.18.1]

### Fixed
- Fixed any type issue for few commands 
- Fixing command help link is broken for 2600B models

## [0.18.0]

### Added
- Added language feature support for 2651A, 2657A and 2601B-PULSE models
- **tsp-toolkit-webhelp:** Added webhelp documents for 2651A, 2657A and 2601B-PULSE models

## [0.16.0]

### Fixed
- **tsp-toolkit-webhelp:** display.input.option() command signature has been corrected for all tti models

## [0.15.3]

### Fixed
- Fixing enums not found issue, from 24xx and 2600B series example scripts

## [0.15.1]

### Changed
- workflow has been added for generaing json artifacts.

<!--Version Comparison Links-->
[Unreleased]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/compare/v0.19.1...HEAD
[0.19.1]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.19.0
[0.19.0]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.19.0
[0.18.4]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.18.4
[0.18.3]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.18.3
[0.18.2]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.18.2
[0.18.1]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.18.1
[0.18.0]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.18.0
[0.16.0]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.16.0
[0.15.3]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.15.3
[0.15.1]: https://github.com/tektronix/tsp-toolkit-webhelp-to-json/releases/tag/v0.15.1
