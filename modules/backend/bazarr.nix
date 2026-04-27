{ config, lib, ... }:

with lib;

let
  cfg = config.deepwoods.backend.bazarr;
in
{
  options.deepwoods.backend.bazarr = {
    enable = mkEnableOption "Bazarr Subtitle Automation";
  };

  config = mkIf cfg.enable {
    services.bazarr = {
      enable = true;
    };

    systemd = {
      services.bazarr.serviceConfig = {
        SupplementaryGroups = [ "media" ];
        ReadWritePaths = [ "/var/lib/transmission/downloads" ];
      };
    };
  };
}
