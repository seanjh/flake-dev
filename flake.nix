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
      in
      {
        devShells = {
          ruby = rubyShell;
        };
      }
    );
}
