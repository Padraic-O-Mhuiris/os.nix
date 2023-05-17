{ config, lib, flake-parts-lib, inputs, ... }:
let
  inherit (lib)
    genAttrs mapAttrs mkOption types zipAttrs attrValues elemAt mkIf;

  inherit (builtins) lessThan length;

  cfg = config.os;

  mkNixosConfiguration = host: hostConfig:
    inputs.nixpkgs.lib.nixosSystem {
      inherit (hostConfig) system;
      modules = [ ];
    };

  nixosConfigurations = lib.mapAttrs mkNixosConfiguration cfg;

  userModule = {
    options = {
      name = mkOption {
        type = types.str;
        default = "";
        description = "The name of the user";
      };
    };
  };

in {
  options.os = mkOption {
    type = types.lazyAttrsOf (types.submodule ({ name, ... }: {
      options = {
        system = mkOption { type = lib.types.enum config.systems; };
        users = mkOption {
          type = types.listOf (types.submodule userModule);
          default = [ ];
          description = "List of user definitions";
        };
      };
    }));
    default = { };
  };

  config.flake = { inherit nixosConfigurations; };

  _file = __curPos.file;
}

