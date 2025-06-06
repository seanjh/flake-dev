{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    {
      templates = {
        basic = {
          path = ./templates/basic;
          description = "Basic starter flake dev environment template";
        };
        ruby = {
          path = ./templates/ruby;
          description = "Ruby development environment";
        };
        ruby-on-rails = {
          path = ./templates/ruby-on-rails;
          description = "Ruby On Rails development environment";
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        rubyShell = import ./templates/ruby/shell.nix { inherit pkgs; };
        claraRailsShell = import ./devenvs/clara-rails/default.nix { inherit pkgs; };
        pythonShell = import ./devenvs/python/default.nix { inherit pkgs; };
      in
      {
        devShells = {
          ruby = rubyShell;
          clara-rails = claraRailsShell;
          python = pythonShell;
        };
      }
    );
}
