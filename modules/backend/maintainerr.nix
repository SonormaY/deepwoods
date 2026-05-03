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
    systemd.tmpfiles.rules = [
      "d /opt/appdata/maintainerr 0775 1000 1000 -"
    ];
    virtualisation = {

        docker.enable = true;
        oci-containers.backend = "docker";

        oci-containers.containers."maintainerr" = {
        image = "ghcr.io/maintainerr/maintainerr:latest";
        extraOptions = [ "--network=host" ];
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
