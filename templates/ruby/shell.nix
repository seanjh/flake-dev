{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    (ruby_3_4.withPackages (
      ps: with ps; [
        solargraph
        bundler
        rubocop
        rubocop-performance
      ]
    ))
    libyaml
  ];
  shellHook = ''
    export GEM_HOME="$PWD/.gem"
    export PATH="$GEM_HOME/bin:$PATH"

    bundle config set --local path '.bundle'
    bundle config set force_ruby_platform true
  '';
}
