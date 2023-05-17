{
  description = "os.nix - A framework for defining nixosConfigurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    #
    home-manager.url = "github:nix-community/home-manager/release-22.11";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
    ({ withSystem, flake-parts-lib, ... }:
      let
        inherit (flake-parts-lib) importApply;
        flakeModules.default = ./flake-module.nix;
        lib = inputs.nixpkgs.lib;
      in {
        debug = true;
        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
        imports = [ flakeModules.default ];

        os = {
          Oxygen = {
            system = "x86_64-linux";
            users = [{ name = "exampleUser1"; }];
          };
          Nitrogen = {
            system = "x86_64-linux";
            # users = [{ name = "exampleUser2"; }];
          };
        };

        flake = { inherit lib flakeModules; };
      });
}
