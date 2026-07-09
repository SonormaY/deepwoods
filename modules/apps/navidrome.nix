{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.deepwoods.apps.navidrome;

  # FIX 1: Add `pname` and change output path to $out/share/${pname}.ndp
  nfoPlugin = pkgs.runCommand "artist-nfo-metadata" {
    pname = "artist-nfo-metadata";
    passthru.isNavidromePlugin = true;
  } ''
    mkdir -p $out/share
    ln -s ${pkgs.fetchurl {
      url = "https://github.com/metalheim/navidrome-plugin-artist-nfo-metadata/releases/download/v1.3.0/artist-nfo-metadata.ndp";
      sha256 = "12ff10kqpxv6b7zii810ma2q1vxwkq1x26aykyzqlpqpjh6crmsl";
    }} $out/share/artist-nfo-metadata.ndp
  '';

  # FIX 2: Add `pname` and change output path to $out/share/${pname}.ndp
  lrclibPlugin = pkgs.runCommand "navidrome-lrclib" {
    pname = "lrclib";
    passthru.isNavidromePlugin = true;
  } ''
    mkdir -p $out/share
    ln -s ${pkgs.fetchurl {
      url = "https://github.com/kepelet/navidrome-lrclib-plugin/releases/download/0.1.0/navidrome-lrclib.ndp";
      sha256 = "0qbly3c0xgql9v90kqlk9pxvd514hlnsam3f7sq3x970irvng0ca";
    }} $out/share/lrclib.ndp
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
      
      plugins = [
        nfoPlugin
        lrclibPlugin
      ];

      settings = {
        MusicFolder = cfg.musicFolder;
        Address = "0.0.0.0";
        Port = 4533;
        
        Plugins = {
          Enabled = true;
        };

        Agents = "artist-nfo-metadata,lastfm,deezer,spotify";
      };
    };

    systemd.services.navidrome = {
      bindsTo = [ "opt-hdd-dependents.target" ];
      after = [ "opt-hdd-dependents.target" ];
      serviceConfig.SupplementaryGroups = [ "media" ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.musicFolder} 0775 navidrome media -"
    ];
  };
}
