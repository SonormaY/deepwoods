{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.deepwoods.backend.torrent;
in
{
  # ============================================================================
  # MODULE OPTIONS
  # ============================================================================

  options.deepwoods.backend.torrent = {
    enable = mkEnableOption "Transmission torrent client";

    downloadDir = mkOption {
      type = types.str;
      default = "/opt/storage/downloads";
      description = "The absolute path where completed torrents will be saved";
    };
  };

  # ============================================================================
  # MODULE IMPLEMENTATION
  # ============================================================================

  config = mkIf cfg.enable {
    users.groups.media = { };

    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;

      group = "media";

      openRPCPort = true;
      openPeerPorts = true;

      settings = {
        download-dir = cfg.downloadDir;
        incomplete-dir-enabled = true;
        incomplete-dir = "${cfg.downloadDir}/.incomplete";

        rpc-bind-address = "0.0.0.0";
        rpc-port = 9091;
        rpc-whitelist-enabled = false;
        rpc-host-whitelist-enabled = false;

        rpc-authentication-required = false;

        peer-port = 51413;
        port-forwarding-enabled = true;
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.downloadDir} 0775 transmission media -"
      "d ${cfg.downloadDir}/.incomplete 0775 transmission media -"
    ];
  };
}
