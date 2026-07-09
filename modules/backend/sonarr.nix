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
      services.sonarr = {
        bindsTo = [ "opt-hdd-dependents.target" ];
        after = [ "opt-hdd-dependents.target" ];

        serviceConfig = {
          SupplementaryGroups = [ "media" ];
          Group = lib.mkForce "media";
        };
      };

      tmpfiles.rules = [
        "d /opt/media/shows 0775 sonarr media -"
      ];
    };
  };
}
