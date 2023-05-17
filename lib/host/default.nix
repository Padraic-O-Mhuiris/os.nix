{ host, hostConfig, lib }:

{
  inherit host hostConfig;

  defaultUser = (lib.elemAt hostConfig.users 0).name;
}
