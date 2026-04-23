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
    ../../modules/backend/transmission.nix
    ../../modules/backend/lidarr.nix
    ../../modules/backend/prowlarr.nix
    ../../modules/backend/radarr.nix
    ../../modules/backend/sonarr.nix
    ../../modules/backend/flaresolverr.nix
    ../../modules/backend/maintainerr.nix
    # Apps
    ../../modules/apps/navidrome.nix
    ../../modules/apps/jellyfin.nix
    ../../modules/apps/jellyseer.nix
    ../../modules/apps/homarr.nix
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
        "torrent.deepwoods.website" = "http://localhost:9091";
        "epona.deepwoods.website" = "ssh://localhost:1488";
        "lidarr.deepwoods.website" = "http://localhost:8686";
        "prowlarr.deepwoods.website" = "http://localhost:9696";
        "radarr.deepwoods.website" = "http://localhost:7878";
        "sonarr.deepwoods.website" = "http://localhost:8989";
        "janitor.deepwoods.website" = "http://localhost:6246";
        # Apps
        "jellyfin.deepwoods.website" = "http://localhost:8096";
        "music.deepwoods.website" = "http://localhost:4533";
        "requests.deepwoods.website" = "http://localhost:5055";
        "dash.deepwoods.website" = "http://localhost:7575";
      };
    };

    backend = {
      torrent = {
        enable = true;
        downloadDir = "/var/lib/transmission/downloads";
        credentialsFile = config.sops.secrets."transmission-creds".path;
      };

      lidarr.enable = true;
      prowlarr.enable = true;
      flaresolverr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      # maintainerr.enable = true;
    };

    apps = {
      navidrome = {
        enable = true;
        musicFolder = "/opt/media/music";
      };

      jellyfin.enable = true;
      jellyseerr.enable = true;
      homarr.enable = true;
    };
  };

  system.stateVersion = "25.11";
}
