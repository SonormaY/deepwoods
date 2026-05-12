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
      group = "media";
    };

    systemd = {
      services.bazarr.serviceConfig = {
        SupplementaryGroups = [ "media" ];
        Group = lib.mkForce "media";
        ReadWritePaths = [ 
          "/var/lib/bazarr"
          "/opt/media"
        ];
        ProtectHome = "read-only";
      };
    };
  };
}
