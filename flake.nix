{
  description = "nix-aether - Nix packaging for Aether, the visual theming application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      aetherPackage = pkgs: pkgs.callPackage ./package.nix { };
    in
    {
      overlays.default = final: _prev: {
        aether = aetherPackage final;
      };
    }
    // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = aetherPackage pkgs;
        packages.aether = aetherPackage pkgs;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            just
            nix-update
          ];
        };
      });
}
