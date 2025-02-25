# flake-dev

A collection of [Nix](https://nixos.org/) flake

## Prerequisites

- [Nix](https://zero-to-nix.com/start/install/) w/ flakes

## Usage

### Environments

```bash
# Start a Ruby development environment shell
nix develop github:seanjh/flake-dev#ruby
```

```bash
# Run a command in the Ruby development environment
nix develop ../flake-dev#ruby --command ruby -e 'puts "Hello, world"'
```

```bash
# In direnv's .envrc
use flake github:seanjh/flake-dev#ruby
```

### Templates

Initialize a new project using one of the available templates:

```bash
# For a Ruby development environment
nix flake init -t github:seanjh/flake-dev#ruby

# For a Ruby on Rails development environment
nix flake init -t github:seanjh/flake-dev#ruby-on-rails
```
