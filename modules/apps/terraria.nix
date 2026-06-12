{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.deepwoods.apps.terraria;
in
{
  options.deepwoods.apps.terraria = {
    enable = mkEnableOption "Terraria Server (TShock)";

    port = mkOption {
      type = types.port;
      default = 7777;
      description = "The port to run the Terraria server on.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.terraria = {
      image = "ryshe/terraria:tshock-latest";
      ports = [ "${toString cfg.port}:7777" ];
      volumes = [
        "/var/lib/terraria/world:/root/.local/share/Terraria/Worlds"
        "/var/lib/terraria/config:/tshock/tshock" # TShock config folder
      ];
      environment = {
        WORLD_FILENAME = "deepwoods.wld";
        AUTOCREATE = "2";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/terraria/world 0775 root root -"
      "d /var/lib/terraria/config 0775 root root -"
    ];
  };
}
