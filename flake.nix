{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    flake-utils.url = "github:numtide/flake-utils/main";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    {
      templates = {
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
