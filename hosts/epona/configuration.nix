{ config, pkgs, ... }:

let
  hosts = import ../../hosts.nix;
in
{
  imports = [
    ../common.nix
    ./hardware.nix
    ../../modules/core/cloudflared.nix
    ../../modules/core/sops.nix
    ../../modules/backend/transmission.nix
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

    ingress = {
      "torrent.deepwoods.website" = "http://localhost:9091";
      "epona.deepwoods.website" = "ssh://localhost:1488";
    };
  };

  deepwoods.backend.torrent = {
    enable = true;
    downloadDir = "/var/lib/transmission/downloads";
    credentialsFile = config.sops.secrets."transmission-creds".path;
  };

  system.stateVersion = "25.11";
}
