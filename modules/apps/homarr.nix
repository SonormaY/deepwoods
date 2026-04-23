{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.deepwoods.apps.dashboard;
in {
  # ============================================================================
  # MODULE OPTIONS
  # ============================================================================
  options.deepwoods.apps.dashboard = {
    enable = mkEnableOption "Homarr Dashboard";
  };

  # ============================================================================
  # MODULE IMPLEMENTATION
  # ============================================================================
  config = mkIf cfg.enable {
    services.homarr = {
      enable = true;
    };
  };
}
