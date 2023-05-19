{ lib }:

let inherit (lib) mapAttrs throwIfNot pathExists;
in rec {
  mkNixosConfiguration = host: hostConfig:
    let
      # lib = lib.extend (final: prev:
      #   prev // {
      #     __os__ = (import ./os.nix ({ inherit host hostConfig; } // final));
      #   });
    in lib.nixosSystem {
      inherit lib;
      inherit (hostConfig) system;
      modules = [

        # (import ../modules/os.nix { inherit host hostConfig; })
      ];
    };

  mkNixosConfigurations = osConfig: mapAttrs mkNixosConfiguration osConfig;

}
