{ host, hostConfig }:

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types elemAt throwIf;
  inherit (builtins) length head;

  cfg = config.os;
in {

  options.os = {
    host = mkOption {
      type = types.str;
      readOnly = true;
      default = host;
    };

    defaultUser = mkOption {
      type = types.str;
      readOnly = true;
      default = throwIf ((length hostConfig.users) == 0)
        "No users have been defined for ${host}" (head hostConfig.users).name;
    };

    # users = mkOption {
    #   type = with types; listOf str;
    #   readOnly = true;
    #   default = __os__.users;
    # };
  };

  config = { };
}
