{ config, lib, ... }:

with lib;

let
  cfg = config.deepwoods.backend.sonarr;
in
{
  options.deepwoods.backend.sonarr = {
    enable = mkEnableOption "Sonarr TV Show Automation";
  };

  config = mkIf cfg.enable {
    services.sonarr = {
      enable = true;
    };
    systemd = {

      services.sonarr.serviceConfig = {
        SupplementaryGroups = [ "media" ];
        ReadWritePaths = [ "/var/lib/transmission/downloads" ];
      };

      tmpfiles.rules = [
        "d /opt/media/shows 0775 sonarr media -"
      ];
    };
  };
}
