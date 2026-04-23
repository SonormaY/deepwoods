{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.deepwoods.apps.jellyseerr;
in {
  options.deepwoods.apps.jellyseerr.enable = mkEnableOption "Jellyseerr Request Management";

  config = mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
    };
  };
}
