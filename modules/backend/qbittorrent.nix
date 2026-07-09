{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.deepwoods.backend.qbittorrent;
in
{
  # ============================================================================
  # MODULE OPTIONS
  # ============================================================================

  options.deepwoods.backend.qbittorrent = {
    enable = mkEnableOption "qBittorrent headless client";

    downloadDir = mkOption {
      type = types.str;
      default = "/opt/storage/downloads";
      description = "The absolute path where completed torrents will be saved";
    };

    webuiPort = mkOption {
      type = types.port;
      default = 8080;
      description = "The port for the Web UI";
    };

    torrentPort = mkOption {
      type = types.port;
      default = 51413;
      description = "The port for incoming peer connections";
    };
  };

  # ============================================================================
  # MODULE IMPLEMENTATION
  # ============================================================================

  config = mkIf cfg.enable {
    users.groups.media = { };

    users.users.qbittorrent = {
      group = "media";
      isSystemUser = true;
      home = "/var/lib/qbittorrent";
      createHome = true;
      description = "qBittorrent Daemon user";
    };

    systemd.services.qbittorrent = {
      description = "qBittorrent-nox service";
      documentation = [ "man:qbittorrent-nox(1)" ];
      after = [ "network.target" "opt-hdd-dependents.target" ];
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "opt-hdd-dependents.target" ];

      serviceConfig = {
        Type = "simple";
        User = "qbittorrent";
        Group = "media";
        UMask = "0002"; 
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${toString cfg.webuiPort}";
        Restart = "on-failure";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ cfg.webuiPort cfg.torrentPort ];
      allowedUDPPorts = [ cfg.torrentPort ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.downloadDir} 0775 qbittorrent media -"
      "d ${cfg.downloadDir}/music 0775 qbittorrent media -"
      "d ${cfg.downloadDir}/movies 0775 qbittorrent media -"
      "d ${cfg.downloadDir}/shows 0775 qbittorrent media -"
      "d ${cfg.downloadDir}/.incomplete 0775 qbittorrent media -"
      "d ${cfg.downloadDir}/.torrent 0775 qbittorrent media -"
      "d ${cfg.downloadDir}/.recyclebin 0775 qbittorrent media -"
    ];
  };
}
