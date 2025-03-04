{
  inputs = {

    nixpkgs.url = "https://flakehub.com/f/nixos/nixpkgs/0.2411.*";
    flake-utils.url = "https://flakehub.com/f/numtide/flake-utils/*";
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
            (ruby_3_3.withPackages (
              ps: with ps; [
                bundler
                ruby-lsp
              ]
            ))
            gcc
            gnumake
            binutils
            rustc
            openssl
            libyaml
            zlib
            gmp
          ];
          shellHook = with pkgs; ''
            export LIBRARY_PATH=${
              lib.makeLibraryPath [
                openssl
                libyaml
                zlib
                gmp
              ]
            }:$LIBRARY_PATH
            export C_INCLUDE_PATH=${
              lib.makeSearchPath "include" [
                openssl.dev
                libyaml.dev
                zlib.dev
                gmp.dev
              ]
            }:$C_INCLUDE_PATH
            export PKG_CONFIG_PATH=${
              lib.makeSearchPath "lib/pkgconfig" [
                openssl.dev
                zlib.dev
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
