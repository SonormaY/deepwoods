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

  config = mkIf cfg.enable {
    users.users.cloudflared = {
      group = "cloudflared";
      isSystemUser = true;
    };
    users.groups.cloudflared = { };

    services.cloudflared = {
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
