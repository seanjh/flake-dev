{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
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
