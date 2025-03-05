# Changelog

## [Unreleased]
### Added
- Integration of multiple execution clients
  - Added Geth configuration
  - Added Erigon configuration with BitTorrent sync support
  - Added Reth (Rust Ethereum) configuration
- Expanded documentation with client comparison tables
- Added detailed metrics endpoint documentation
- Created integration guide for adding new execution clients
- Environment variables for client-specific configuration options
- Added `EXECUTION_CLIENT` environment variable to make client combinations more flexible

### Changed
- Updated README to reflect multiple execution client support
- Improved Prometheus configuration with new client metrics
- Restructured deployment instructions for clarity
- Updated service resource limit configuration

### Fixed
- Fixed port conflict handling between execution clients
- Ensured consistent JWT auth configuration across clients
- Resolved Reth metrics port conflict by using alternative port mapping
- Fixed Reth JWT secret parameter (changed from file path to actual hex value)
- Fixed Reth pruning configuration to use the correct parameter format
- Improved Docker Compose configuration for Reth with proper entrypoint syntax
- Updated Reth Docker image location to use the correct repository