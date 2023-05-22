# This lib file is to be passed in context of the mkNixosConfiguration function
# defined in the os flakeModule

{ host, hostConfig, ... }@lib:

let
  inherit (lib) mkOption types elemAt;
  inherit (builtins) length head map;
in rec {

  defaultUser = if (length hostConfig.users > 0) then
    (head hostConfig.users).name
  else
    null;

  users = map (x: x.name) hostConfig.users;

  assertions = [{
    assertion = defaultUser != null;
    message = "${host} os definition did not specify a user definition";
  }];
}
