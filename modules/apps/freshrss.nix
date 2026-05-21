{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.deepwoods.apps.freshrss;
in {
  options.deepwoods.apps.freshrss = {
    enable = mkEnableOption "FreshRSS Feed Aggregator";
  };

  config = mkIf cfg.enable {
    services.freshrss = {
      enable = true;
      baseUrl = "https://rss.deepwoods.website";

      database = {
        type = "sqlite";
      };

      defaultUser = "sonorma";
      passwordFile = "/var/lib/freshrss/admin-password";
    };

    systemd.services.freshrss-init = {
      serviceConfig.ReadWritePaths = [ "/var/lib/freshrss" ];
    };
  }
}
