{ pkgs }:
pkgs.mkShell {

  packages = with pkgs; [
    (ruby_3_4.withPackages (
      ps: with ps; [
        solargraph
        bundler
        rubocop

        bigdecimal
        io-console
        racc
        psych
        # strscan
        stringio
        date
        json
        net-http
        net-protocol
        net-smtp
      ]
    ))
    libyaml
  ];
  shellHook = ''
    export GEM_HOME="$PWD/.gem"
    export PATH="$GEM_HOME/bin:$PATH"
    if [ ! -f Gemfile.lock ]; then
        echo "Installing gems..."
        bundle install
    fi

    bundle config set --local path '.bundle'
    bundle config set force_ruby_platform true
    bundle config set --local without 'production'
  '';
}
