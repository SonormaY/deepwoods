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

  deepwoods.core.cloudflared = {
    enable = true;
    tunnelId = "4b26bc6d-4f64-4b1b-92e1-d2bb3ea1afb6";

    credentialsFile = config.sops.secrets.cloudflared-creds.path;
    certificateFile = "/home/sonorma/.cloudflared/cert.pem";

    ingress = {
      "torrent.deepwoods.website" = "http://localhost:9091";
      "epona.deepwoods.website" = "ssh://localhost:1488";
      "music.deepwoods.website" = "http://localhost:4533";
      "lidarr.deepwoods.website" = "http://localhost:8686";
      "prowlarr.deepwoods.website" = "http://localhost:9696";
    };
  };

  deepwoods.backend.torrent = {
    enable = true;
    downloadDir = "/var/lib/transmission/downloads";
    credentialsFile = config.sops.secrets."transmission-creds".path;
  };

  deepwoods.apps.navidrome = {
    enable = true;
    musicFolder = "/opt/media/music";
  };

  deepwoods.backend.lidarr.enable = true;
  deepwoods.backend.prowlarr.enable = true;

  system.stateVersion = "25.11";
}
