{
  description = "hn-sample";

  inputs.haskellNix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = self: _: {
          hsPkgs =
            self.haskell-nix.project' rec {
              src = ./.;
              compiler-nix-name = "ghc8107";
              shell = {
                tools = {
                  cabal = "latest";
                  ghcid = "latest";
                  haskell-language-server = "latest";
                  hlint = "latest";
                  };
                };
              };
            };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            haskellNix.overlay
            overlay
          ];
        };
        flake = pkgs.hsPkgs.flake { };
      in
      flake // { defaultPackage = flake.packages."hn-sample:exe:hn-sample-exe"; }
    );
}
