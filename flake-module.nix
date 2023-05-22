{ config, flake-parts-lib, inputs, flake, ... }:

let
  lib = inputs.nixpkgs.lib.extend (final: prev:
    prev // {
      os = import ./lib {
        inherit inputs;
        lib = final;
      };
    });

  inherit (lib) mkOption types throwIf throwIfNot pathExists mapAttrs length;
  inherit (lib.os) mkNixosConfiguration;

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
  config.os = throwIfNot (pathExists ./os.nix)
    "Could not find ./os.nix in the project root directory"
    (import ./os.nix { inherit inputs lib flake; });

  options.os = mkOption {
    type = types.lazyAttrsOf (types.submodule ({ name, ... }: {
      options = {
        system = mkOption { type = lib.types.enum config.systems; };
        users = mkOption {
          type = types.listOf (types.submodule usersModule);
          default = [ ];
          apply = x: throwIf (length x == 0) "No users listed for" x;
          description = "List of user definitions";
        };
      };
    }));
    default = { };
  };

  config.flake = {
    inherit lib;
    nixosConfigurations = mapAttrs mkNixosConfiguration config.os;
  };
}

# TODO
#
# - Enforce usage of an os.nix file which returns just an attrset, throw if file does not exist
# - Will require flake-parts
