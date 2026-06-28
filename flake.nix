{
  description = "wheresourplayground Jekyll site";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }: let
    lib = import ./nix/jekyll-site-lib.nix { inherit nixpkgs; };
  in {
    devShells = lib.forAllSystems (system: {
      jekyll-site = lib.mkDevShell {
        inherit system;
        ruby = "ruby_3_3";
        withNokogiri = false;
        withSassc = false;
      };
    });
  };
}
