{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.deepwoods.apps.navidrome;
in
{
  options.deepwoods.apps.navidrome = {
    enable = mkEnableOption "Navidrome Music Server";

    musicFolder = mkOption {
      type = types.str;
      default = "/opt/media/music";
      description = "The absolute path where music will be stored";
    };
  };

  config = mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      settings = {
        MusicFolder = cfg.musicFolder;
        Address = "0.0.0.0";
        Port = 4533;
      };
    };

    systemd.services.navidrome.serviceConfig.SupplementaryGroups = [ "media" ];

    systemd.tmpfiles.rules = [
      "d ${cfg.musicFolder} 0775 navidrome media -"
    ];
  };
}
