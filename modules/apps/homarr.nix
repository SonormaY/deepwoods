{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.deepwoods.apps.homarr;
in {
  # ============================================================================
  # MODULE OPTIONS
  # ============================================================================
  options.deepwoods.apps.homarr = {
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
