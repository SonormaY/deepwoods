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
    # Apps
    ../../modules/apps/navidrome.nix
  ];

  networking.hostName = "epona";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sops.secrets."transmission-creds" = {
    owner = "transmission";
  };

  # ============================================================================
  # SERVICES
  # ============================================================================
  deepwoods = {

    core.cloudflared = {
      enable = true;
      certificateFile = "/home/sonorma/.cloudflared/cert.pem";
      tunnelId = "4b26bc6d-4f64-4b1b-92e1-d2bb3ea1afb6";

      credentialsFile = config.sops.secrets.cloudflared-creds.path;

      ingress = {
        "epona.deepwoods.website" = "ssh://localhost:1488";
        "music.deepwoods.website" = "http://localhost:4533";
        "lidarr.deepwoods.website" = "http://localhost:8686";
        "prowlarr.deepwoods.website" = "http://localhost:9696";
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
    };

    apps.navidrome = {
      enable = true;
      musicFolder = "/opt/media/music";
    };
  };

  system.stateVersion = "25.11";
}
