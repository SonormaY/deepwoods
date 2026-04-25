{ config, pkgs, lib, ... }:

let
  cfg = config.deepwoods.apps.minecraft;
  modpack = pkgs.fetchPackwizModpack {
    url = "https://raw.githubusercontent.com/SonormaY/deepwoods/refs/heads/main/mc_fabric_pack/pack.toml";
    packHash = "sha256-XAXEPUPYaUpa6o6O6DkUC1sw1Cswcrl4e684SLthTPk=";
  };
in {
  options.deepwoods.apps.minecraft = {
    enable = lib.mkEnableOption "Fabric Minecraft Server";
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers.fabric = {
        enable = true;

        package = pkgs.fabricServers.fabric-26_1_2.override {
          loaderVersion = "0.19.2";
        };

        jvmOpts = "-Xms4G -Xmx4G";

        serverProperties = {
          server-port = 25565;
          difficulty = 3;
          gamemode = "survival";
          motd = "Welcome to the Deepwoods!";
          white-list = true;
        };

        whitelist = {
          sonormay = "724e39c4-9e55-40a8-9252-0a9170b4cf19";
        };

        symlinks = {
          "mods" = "${modpack}/mods";
        };

        files = {
          "config" = "${modpack}/config";
        };
      };
    };
  };
}
