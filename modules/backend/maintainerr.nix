{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.deepwoods.backend.maintainerr;
in {
  # ============================================================================
  # MODULE OPTIONS
  # ============================================================================
  options.deepwoods.backend.maintainerr = {
    enable = mkEnableOption "Maintainerr Container";
  };

  # ============================================================================
  # MODULE IMPLEMENTATION
  # ============================================================================
  config = mkIf cfg.enable {
    virtualisation = {

        docker.enable = true;
        oci-containers.backend = "docker";

        oci-containers.containers."maintainerr" = {
        image = "ghcr.io/jorenn92/maintainerr:latest";
        ports = [ "6246:6246" ];
        volumes = [
            "/opt/appdata/maintainerr:/opt/data"
        ];
        environment = {
            TZ = config.time.timeZone;
        };
        autoStart = true;
        };
    };
  };
}
