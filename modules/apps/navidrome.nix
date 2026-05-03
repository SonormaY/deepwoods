{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.deepwoods.apps.navidrome;

  nfoPlugin = pkgs.fetchurl {
    url = "https://github.com/metalheim/navidrome-plugin-artist-nfo-metadata/releases/download/v1.3.0/artist-nfo-metadata.ndp";
    sha256 = "12ff10kqpxv6b7zii810ma2q1vxwkq1x26aykyzqlpqpjh6crmsl";
  };

  navidromePlugins = pkgs.runCommand "navidrome-plugins" {} ''
    mkdir -p $out
    ln -s ${nfoPlugin} $out/artist-nfo-metadata.ndp
  '';

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

        Plugins = {
          Enabled = true;
          Folder = "${navidromePlugins}";
        };

        Agents = "artist-nfo-metadata,lastfm,deezer,spotify";
      };
    };

    systemd.services.navidrome.serviceConfig.SupplementaryGroups = [ "media" ];

    systemd.tmpfiles.rules = [
      "d ${cfg.musicFolder} 0775 navidrome media -"
    ];
  };
}
