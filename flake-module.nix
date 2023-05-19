{ config, flake-parts-lib, inputs, ... }:

let
  lib = inputs.nixpkgs.lib.extend
    (final: prev: prev // { os = import ./lib { lib = final; }; });

  inherit (lib) mkOption types throwIfNot pathExists fallibleImport hasAttr;
  inherit (lib.os) mkNixosConfigurations;

  os = throwIfNot (hasAttr "os" config.flake) "No os attr defined in flake"
    config.flake.os;

  usersModule = {
    options = {
      name = mkOption {
        type = types.str;
        default = "";
        description = "The name of the user";
      };
    };
  };

in {
  config = { inherit os; };
  options.os = mkOption {
    type = types.lazyAttrsOf (types.submodule ({ name, ... }: {
      options = {
        system = mkOption { type = lib.types.enum config.systems; };
        users = mkOption {
          type = types.listOf (types.submodule usersModule);
          default = [ ];
          description = "List of user definitions";
        };
      };
    }));
    default = { };
  };

  config.flake = {
    inherit lib;
    nixosConfigurations = mkNixosConfigurations config.os;
  };
}

# TODO
#
# - Enforce usage of an os.nix file which returns just an attrset, throw if file does not exist
# - Will require flake-parts
