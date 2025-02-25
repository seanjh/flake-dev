# flake-dev

A collection of [Nix](https://nixos.org/) flake templates and environments. Generally the templates at [NixOS/templates](https://github.com/NixOS/templates/tree/master) and [the-nix-way/dev-templates](https://github.com/the-nix-way/dev-templates) and the dev environments at [the-nix-way/nix-flake-dev-environments](https://github.com/the-nix-way/nix-flake-dev-environments) are better, but these ones are mine and special to me.

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
use flake github:seanjh/flake-dev#ruby-on-rails
```

### Templates

Initialize a new project using one of the available templates:

```bash
# For a Ruby development environment
nix flake init -t github:seanjh/flake-dev-templates#ruby

# For a Ruby on Rails development environment
nix flake init -t github:seanjh/flake-dev-templates#ruby-on-rails
```
