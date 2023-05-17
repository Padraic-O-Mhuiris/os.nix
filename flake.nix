{
  description = "os.nix - A framework for defining nixosConfigurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
        systems = [ "x86_64-linux" ];
        imports = [ flakeModules.default ];

        os = {
          Oxygen = {
            system = "x86_64-lin";
            # users = [{ name = "exampleUser"; }];
          };
          Nitrogen = {
            system = "x86_64-linux";
            # users = [{ name = "exampleUser"; }];
          };
        };
        # perSystem = _: {
        #   os = {
        #     Oxygen = {
        #       system = "x86_64-linux";
        #       # users = [{ name = "exampleUser"; }];
        #     };
        #   };
        # };

        flake = { inherit lib flakeModules; };
      });
}
