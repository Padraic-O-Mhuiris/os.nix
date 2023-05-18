{ host, hostConfig }:

{ config, lib, ... }:

let
  inherit (lib) mkOption types elemAt __os__;
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
      type = with types; nullOr str;
      readOnly = true;
      default = __os__.defaultUser;
    };

    users = mkOption {
      type = with types; listOf str;
      readOnly = true;
      default = __os__.users;
    };
  };

  config = { inherit (__os__) assertions; };
}
