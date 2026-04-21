{ config, lib, ... }:

with lib;

let
  cfg = config.deepwoods.backend.lidarr;
in
{
  options.deepwoods.backend.lidarr = {
    enable = mkEnableOption "Lidarr Music Automation";
  };

  config = mkIf cfg.enable {
    services.lidarr = {
      enable = true;
    };

    systemd.services.lidarr.serviceConfig.SupplementaryGroups = [ "media" ];
  };
}
