{ inputs, lib }:

let inherit (lib) mapAttrs throwIfNot pathExists hasAttr;
in rec {

  mkNixosConfiguration = host: hostConfig:
    let
      # lib = lib.extend (final: prev:
      #   prev // {
      #     __os__ = (import ./os.nix ({
      #       inherit host hostConfig;
      #       lib = final;
      #     }));
      #   });
    in lib.nixosSystem {
      inherit lib;
      inherit (hostConfig) system;
      modules = [

        ({
          fileSystems."/" = { };

          boot.loader.grub = {
            enable = true;
            device = "nodev";
          };
          system.stateVersion = "23.05";
        })
        inputs.home-manager.nixosModules.home-manager
        # (import ../modules/os.nix { inherit host hostConfig; })

      ];
    };
}
