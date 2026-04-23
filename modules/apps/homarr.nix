{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.deepwoods.apps.homarr;
in {
  options.deepwoods.apps.homarr = {
    enable = mkEnableOption "Homarr Dashboard (OCI)";
  };

  config = mkIf cfg.enable {
    virtualisation = {
        docker.enable = true;
        oci-containers.backend = "docker";

        oci-containers.containers.homarr = {
          image = "ghcr.io/homarr-labs/homarr:latest";

          inherit (cfg) keyFile;

          environment = {
            TZ = config.time.timeZone;
          };

          ports = [ "7575:7575" ];

          volumes = [
            "/opt/appdata/homarr:/appdata"
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
        };
    };

    sops.secrets."homarr_env" = {
      sopsFile = ../../secrets/secrets.yaml;
      restartUnits = [ "docker-homarr.service" ]; 
    };
  };
}

