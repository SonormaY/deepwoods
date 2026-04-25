{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.deepwoods.apps.seerr;
in {
  options.deepwoods.apps.seerr.enable = mkEnableOption "Seerr Request Management";

  config = mkIf cfg.enable {
    services.seerr = {
      enable = true;
    };
  };
}
