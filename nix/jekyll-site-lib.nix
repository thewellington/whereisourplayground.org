{ nixpkgs }:
let
  lib = nixpkgs.lib;
  systems = [
    "aarch64-darwin"
    "x86_64-darwin"
    "x86_64-linux"
    "aarch64-linux"
  ];
in
{
  inherit systems;
  forAllSystems = lib.genAttrs systems;

  mkDevShell =
    {
      system,
      ruby ? "ruby_3_3",
      withNokogiri ? false,
      withSassc ? false,
      extraPackages ? [ ],
    }:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      rubyPkg = pkgs.${ruby} or pkgs.ruby_3_3;
      bundler = pkgs.bundler.override { ruby = rubyPkg; };

      basePkgs = with pkgs; [
        pkg-config
        libffi
        openssl
        zlib
        clang
        gnumake
      ];
      nokogiriPkgs = lib.optionals withNokogiri (with pkgs; [
        libxml2
        libxslt
      ]);
      sasscPkgs = lib.optionals withSassc (with pkgs; [
        libsass
      ]);

      nokogiriHook = lib.optionalString withNokogiri ''
        export NOKOGIRI_USE_SYSTEM_LIBRARIES=1
        export PKG_CONFIG_PATH="${pkgs.libxml2.dev}/lib/pkgconfig:${pkgs.libxslt.dev}/lib/pkgconfig''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
      '';
    in
    pkgs.mkShellNoCC {
      name = "jekyll-site";
      packages = lib.unique (
        [ rubyPkg bundler ] ++ basePkgs ++ nokogiriPkgs ++ sasscPkgs ++ extraPackages
      );

      shellHook = ''
        export name=jekyll-site
        export BUNDLE_PATH="$PWD/vendor/bundle"
        export BUNDLE_BIN="$PWD/vendor/bundle/bin"
        export GEM_HOME="$PWD/vendor/bundle"
        export GEM_PATH="$PWD/vendor/bundle"
        export PATH="$BUNDLE_BIN:${bundler}/bin:$PATH"
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
        export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        ${nokogiriHook}

        bundleExe="${bundler}/bin/bundle"
        if ! $bundleExe check >/dev/null 2>&1; then
          echo "Installing gems..."
          $bundleExe config set --local path 'vendor/bundle'
          $bundleExe install
        fi

        echo "jekyll-site ready: $(ruby -v)"
        echo "Run: bundle exec jekyll serve --livereload"
      '';
    };
}
