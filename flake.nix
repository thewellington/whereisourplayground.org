{
  description = "Where Is Our Playground — Jekyll + Bundler dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = false;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            ruby_3_3
            bundler
            pkg-config
            libffi
            starship
          ];

          shellHook = ''
            export BUNDLE_PATH="$PWD/vendor/bundle"
            echo "Ruby: $(ruby --version)"
            echo "Bundler: $(bundle --version)"
            echo "Run: bundle install && bundle exec jekyll serve"
            # Interactive `nix develop` uses bash. direnv imports env vars, not prompt — keep `starship init zsh` in ~/.zshrc; `starship` on PATH is from this flake.
            if [[ -t 1 && ''${TERM-} != dumb ]]; then
              if [[ -n ''${ZSH_VERSION-} ]]; then
                eval "$(starship init zsh)"
              else
                eval "$(starship init bash)"
              fi
            fi
          '';
        };
      }
    );
}
