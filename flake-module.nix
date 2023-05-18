{ config, lib, flake-parts-lib, inputs, ... }:

let

  # lib = inputs.nixpkgs.lib.extend
  #   (final: prev: prev // { os = import ./lib final; });

  inherit (lib)
    genAttrs mapAttrs mkOption types zipAttrs attrValues elemAt mkIf;

  inherit (builtins) lessThan length;

  cfg = config.os;

  nixosConfigurations = { }; # mapAttrs lib.os.mkNixosConfiguration cfg;

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

  config.flake = { inherit nixosConfigurations; };

  _file = __curPos.file;
}
