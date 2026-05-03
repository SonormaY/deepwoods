{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.deepwoods.backend.qbit-manage;
in
{
  options.deepwoods.backend.qbit-manage = {
    enable = mkEnableOption "qBit Manage container";

    downloadDir = mkOption {
      type = types.str;
      default = "/opt/storage/downloads";
      description = "The base download directory qbit_manage needs to access for cross-seeding";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /var/lib/qbit-manage/config 0775 root root -"
    ];

    virtualisation.oci-containers.containers.qbit-manage = {
      image = "hotio/qbit_manage:latest";
      environment = {
        PUID = "0";
        PGID = "0";
        TZ = "Europe/Kyiv";
      };
      volumes = [
        "/var/lib/qbit-manage/config:/config"
        "${cfg.downloadDir}:${cfg.downloadDir}:rw"
      ];
    };
  };
}
