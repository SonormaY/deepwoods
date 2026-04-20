{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common/default.nix
  ];

  networking.hostName = "epona";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";
}
