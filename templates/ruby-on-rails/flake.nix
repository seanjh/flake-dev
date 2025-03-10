{
  description = "Ruby on Rails development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            (ruby_3_4.withPackages (
              ps: with ps; [
                bundler
                ruby-lsp
                erb-formatter
              ]
            ))
            pkg-config
            gcc
            gnumake
            binutils
            rustc
            openssl
            libyaml
            zlib
            gmp
            vips
          ];
          shellHook = with pkgs; ''
            export LIBRARY_PATH=${
              lib.makeLibraryPath [
                openssl
                libyaml
                zlib
                gmp
                vips
              ]
            }:$LIBRARY_PATH
            export LD_LIBRARY_PATH=${
              lib.makeLibraryPath [
                openssl
                libyaml
                zlib
                gmp
                vips
              ]
            }:$LD_LIBRARY_PATH
            export C_INCLUDE_PATH=${
              lib.makeSearchPath "include" [
                openssl.dev
                libyaml.dev
                zlib.dev
                gmp.dev
                vips.dev
              ]
            }:$C_INCLUDE_PATH
            export PKG_CONFIG_PATH=${
              lib.makeSearchPath "lib/pkgconfig" [
                openssl.dev
                zlib.dev
                vips.dev
              ]
            }:$PKG_CONFIG_PATH

            export GEM_HOME="$PWD/.gem"
            export PATH="$PWD/bin:$GEM_HOME/bin:$PATH"
            if [ ! -f "$GEM_HOME/bin/rails" ]; then
              gem install rails
            fi

            bundle config set --local path '.bundle'
            bundle config set force_ruby_platform true
          '';
        };
      }
    );
}
