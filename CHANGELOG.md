# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

*Note*: We try to adhere to these practices as of version [v1.1.0].

## Version [1.2.2] - 2024-06-11

### Changed

- Renamed `PCD` to `PCM` to make it clearer that this simply runs persistent Markov chains, not contrastive divergence. [#14]
- Improved `mcmc_samples` to now allow mini-batch training. [#14]

## Version [1.2.1] - 2024-06-06

### Removed

- No longer clipping generated samples at extrema of prior. [#13]

## Version [1.2.0] - 2024-06-05

### Added

- Added support for running Persistent Markov Chains (PMC) on models. [#10]

## Version [1.1.1] - 2024-06-04

### Changed

- Improved the samplers and added proper unit tests. [#8]

## Version [1.1.0] - 2024-05-23

### Added

- Added samplers from [JointEnergyModels.jl](https://github.com/JuliaTrustworthyAI/JointEnergyModels.jl). 