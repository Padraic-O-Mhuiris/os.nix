{ inputs, lib, flake }: {
  Oxygen = {
    system = "x86_64-linux";
    # users = [ { name = "exampleUser1"; } { name = "xxxx"; } ];
    users = [ ];
  };
}
