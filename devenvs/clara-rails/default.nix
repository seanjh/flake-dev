{ pkgs }:

let
  customGemsOverlay = final: prev: {
    rubyPackages_3_3 = prev.rubyPackages_3_3 // {
      ruby-lsp-rails = prev.buildRubyGem rec {
        name = "${gemName}-${version}";
        gemName = "ruby-lsp-rails";
        ruby = prev.ruby_3_3;
        version = "0.4.2";

        src = final.fetchurl {
          url = "https://rubygems.org/downloads/${gemName}-${version}.gem";
          sha256 = "sha256-luxuPoPeCEt8Vanagy1qf+I+WDJ7inrbiP2ETbse3OE=";
        };
        propagatedBuildInputs = [ prev.rubyPackages_3_3.ruby-lsp ];
      };
    };
  };

  pkgsWithOverlays = import pkgs.path {
    inherit (pkgs) system;
    overlays = [
      customGemsOverlay
    ];
  };
in

pkgsWithOverlays.mkShell {
  packages = with pkgsWithOverlays; [
    (ruby_3_3.withPackages (
      ps: with ps; [
        bundler
        rails
        prism
        standard
        ruby-lsp
        pkgsWithOverlays.rubyPackages_3_3.ruby-lsp-rails
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
    postgresql_16
    nodejs_20
    pgcli
    heroku
  ];

  shellHook = with pkgsWithOverlays; ''
    # isolate any accidental or purposeful "gem install"s here
    export GEM_HOME="$PWD/.gem"
    mkdir -p $GEM_HOME
    export BUNDLE_DIR='.bundle'
    export PATH="$PWD/bin:$PWD/$BUNDLE_DIR/ruby/*/bin:$PATH:$GEM_HOME/bin"

    bundle config set --local path "$BUNDLE_DIR"

    # via https://github.com/rails/rails/issues/38560#issuecomment-1881733872
    # Work around for these errors on startup:
    # objc[11443]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.
    export PGGSSENCMODE=disable

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
  '';
}
