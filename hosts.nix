# hosts.nix
{
  epona = {
    ip = "192.168.50.2";
    port = 1488;
    user = "sonorma";
    tags = [
      "production"
      "core"
    ];
  };
}
