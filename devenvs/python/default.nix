{ pkgs }:

let
  pythonOverlay = final: prev: {
    python313 = prev.python313.overrideAttrs (old: rec {
      version = "3.13.3";
      src = final.fetchurl {
        url = "https://www.python.org/ftp/python/${version}/Python-${version}.tgz";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
    });
  };

  pkgsWithOverlays = import pkgs.path {
    inherit (pkgs) system;
    overlays = [ pythonOverlay ];
  };
in

pkgsWithOverlays.mkShell {
  packages = with pkgsWithOverlays; [
    (python313.withPackages (
      ps: with ps; [
        pip
        virtualenv
        uv
      ]
    ))
  ];

  shellHook = ''
    export VIRTUAL_ENV=".venv"
    export PATH="$PWD/$VIRTUAL_ENV/bin:$PATH"
  '';
}

