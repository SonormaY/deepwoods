{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.deepwoods.core.cloudflared;
in
{
  # ============================================================================
  # MODULE OPTIONS
  # ============================================================================

  options.deepwoods.core.cloudflared = {
    enable = mkEnableOption "Cloudflared tunnel service";

    tunnelId = mkOption {
      type = types.str;
      description = "The UUID of the Cloudflared tunnel";
    };

    credentialsFile = mkOption {
      type = types.str;
      description = "Path to the tunnel credentials file (managed by sops-nix)";
    };

    certificateFile = mkOption {
      type = types.str;
      description = "Path to the tunnel certificate file";
    };

    ingress = mkOption {
      type = types.attrs;
      default = { };
      description = "Ingress rules mapping domains to local services";
      example = {
        "*.domain.com" = "http://localhost:80";
      };
    };
  };

  # ============================================================================
  # MODULE IMPLEMENTATION
  # ============================================================================

  config = {
    users.users.cloudflared = {
      group = "cloudflared";
      isSystemUser = true;
    };
    users.groups.cloudflared = { };

    services.cloudflared = mkIf cfg.enable {
      enable = true;
      tunnels = {
        "${cfg.tunnelId}" = {
          inherit (cfg) credentialsFile;
          inherit (cfg) ingress;
          default = "http_status:404";
        };
      };
    };
  };
}
