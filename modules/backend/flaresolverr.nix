{ config, lib, ... }:

with lib;

let
  cfg = config.deepwoods.backend.flaresolverr;
in
{
  options.deepwoods.backend.flaresolverr = {
    enable = mkEnableOption "FlareSolverr proxy for Cloudflare bypass";
  };

  config = mkIf cfg.enable {
    services.flaresolverr = {
      enable = true;
      port = 8191;
    };
  };
}
