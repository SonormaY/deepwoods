{ config, pkgs, ... }:

let
  hosts = import ../../hosts.nix;
in
{
  imports = [
    ../common.nix
    ./hardware.nix
  ];

  networking.hostName = "epona";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";
}
