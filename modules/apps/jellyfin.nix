{ config, lib, ... }:

with lib;

let
  cfg = config.deepwoods.apps.jellyfin;
in
{
  options.deepwoods.apps.jellyfin = {
    enable = mkEnableOption "Jellyfin Media Server";
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
    };

    systemd.services.jellyfin.serviceConfig.SupplementaryGroups = [ "media" ];
  };
}
