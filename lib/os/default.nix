{ host, hostConfig, lib }:

let inherit (lib) elemAt;
in {
  inherit host hostConfig;

  defaultUser = (elemAt hostConfig.users 0).name;
}
