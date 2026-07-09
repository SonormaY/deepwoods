{ config, pkgs, ... }:

let
  hosts = import ../../hosts.nix;
in
{
  imports = [
    ../common.nix
    ./hardware.nix
    # Core
    ../../modules/core/cloudflared.nix
    ../../modules/core/sops.nix
    # Backend
    ../../modules/backend/qbittorrent.nix
    ../../modules/backend/qbit-manage.nix
    ../../modules/backend/lidarr.nix
    ../../modules/backend/prowlarr.nix
    ../../modules/backend/radarr.nix
    ../../modules/backend/sonarr.nix
    ../../modules/backend/flaresolverr.nix
    ../../modules/backend/maintainerr.nix
    ../../modules/backend/bazarr.nix
    ../../modules/backend/obsidian-sync.nix
    # Apps
    ../../modules/apps/navidrome.nix
    ../../modules/apps/jellyfin.nix
    ../../modules/apps/seerr.nix
    ../../modules/apps/homarr.nix
    ../../modules/apps/minecraft.nix
    ../../modules/apps/freshrss.nix
    ../../modules/apps/terraria.nix
  ];

  networking.hostName = "epona";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================================================
  # SERVICES
  # ============================================================================
  deepwoods = {

    core.cloudflared = {
      enable = true;
      tunnelId = "823ebdbd-734f-484e-bcc0-336bad417b6e";

      credentialsFile = config.sops.secrets.cloudflared-creds.path;
      certificateFile = "/home/sonorma/.cloudflared/cert.pem";

      ingress = {
        # Backend
        "torrent.deepwoods.website" = "http://localhost:8080";
        "epona.deepwoods.website" = "ssh://localhost:1488";
        "lidarr.deepwoods.website" = "http://localhost:8686";
        "prowlarr.deepwoods.website" = "http://localhost:9696";
        "radarr.deepwoods.website" = "http://localhost:7878";
        "sonarr.deepwoods.website" = "http://localhost:8989";
        "bazarr.deepwoods.website" = "http://localhost:6767";
        "maintainerr.deepwoods.website" = "http://localhost:6246";
        # Apps
        "jellyfin.deepwoods.website" = "http://localhost:8096";
        "music.deepwoods.website" = "http://localhost:4533";
        "seerr.deepwoods.website" = "http://localhost:5055";
        "dash.deepwoods.website" = "http://localhost:7575";
        "mc.deepwoods.website" = "tcp://localhost:25565";
        "rss.deepwoods.website" = "http://localhost:80";
        "obsidian.deepwoods.website" = "http://localhost:5984";
      };
    };

    backend = {
      qbittorrent = {
        enable = true;
        downloadDir = "/var/lib/torrent";
      };

      lidarr.enable = true;
      prowlarr.enable = true;
      flaresolverr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      bazarr.enable = true;
      maintainerr.enable = true;
      qbit-manage.enable = true;
    };

    apps = {
      navidrome = {
        enable = true;
        musicFolder = "/opt/media/music";
      };

      homarr = {
        enable = true;
        environmentFile = config.sops.secrets."homarr-encryption-key".path;
      };

      jellyfin.enable = true;
      seerr.enable = true;
      minecraft.enable = true;
      freshrss.enable = true;
      terraria.enable = true;

    };
  };
  
  systemd = {
    tmpfiles.rules = [
      #Type  SymlinkPath        Mode  User         Group  Age  TargetPath
      "L+    /opt/media         -     -            -      -    /opt/hdd/media"
      "L+    /var/lib/torrent   -     -            -      -    /opt/hdd/torrent"
      "d     /opt/hdd/media     0775  sonarr       media  -    -"
      "d     /opt/hdd/torrent   0775  qbittorrent  media  -    -"
    ];
  
    services."systemd-tmpfiles-setup" = {
      requires = [ "opt-hdd.mount" ];
      after = [ "opt-hdd.mount" ];
    };
    targets.opt-hdd-dependents = {
      description = "Services requiring /opt/hdd";
      requires = [ "opt-hdd.mount" ];
      after = [ "opt-hdd.mount" ];
    };
  };

  system.stateVersion = "26.11";
}
