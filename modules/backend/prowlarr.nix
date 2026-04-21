{ config, lib, ... }:

with lib;

let
  cfg = config.deepwoods.backend.prowlarr;
in
{
  options.deepwoods.backend.prowlarr = {
    enable = mkEnableOption "Prowlarr Indexer Manager";
  };

  config = mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
    };
  };
}
