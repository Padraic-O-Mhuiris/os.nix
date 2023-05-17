{ config, lib, flake-parts-lib, inputs, ... }:
let
  inherit (lib) genAttrs mapAttrs mkOption types zipAttrs attrValues;

  cfg = config.os;

  mkNixosConfiguration = _: hostConfig:
    inputs.nixpkgs.lib.nixosSystem {
      inherit (hostConfig) system;
      modules = [ ];
    };

  nixosConfigurations = lib.mapAttrs mkNixosConfiguration config.os;

in {
  options.os = mkOption {
    type = types.lazyAttrsOf (types.submodule ({ name, ... }: {
      options = {
        system = lib.mkOption {
          type = lib.types.enum [ "x86_64-linux" "aarch64-linux" ];
        };
      };
    }));
  };

  config.flake = { inherit nixosConfigurations; };

  _file = __curPos.file;
}

