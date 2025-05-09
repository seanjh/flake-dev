{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2411.*";
    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";
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
