{ config, lib, ... }:

with lib;

let
  cfg = config.deepwoods.backend.radarr;
in
{
  options.deepwoods.backend.radarr = {
    enable = mkEnableOption "Radarr Movie Automation";
  };

  config = mkIf cfg.enable {
    services.radarr = {
      enable = true;
    };
    systemd = {

      services.radarr.serviceConfig = {
        SupplementaryGroups = [ "media" ];
        ReadWritePaths = [ "/var/lib/transmission/downloads" ];
      };

      tmpfiles.rules = [
        "d /opt/media/movies 0775 radarr media -"
      ];
    };
  };
}
