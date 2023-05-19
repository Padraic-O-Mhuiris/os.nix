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
    (let flakeModules.default = import ./flake-module.nix;
    in {
      debug = true;
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      imports = [ flakeModules.default ];
      flake = {
        inherit flakeModules;

        os = {
          Oxygen = {
            system = "x86_64-linux";
            users = [ { name = "exampleUser1"; } { name = "xxxx"; } ];
          };
          # Nitrogen = {
          #   system = "x86_64-linux";
          #   # users = [{ name = "exampleUser2"; }];
          # };
        };
      };
    });
}
