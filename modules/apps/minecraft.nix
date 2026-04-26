{ config, pkgs, lib, ... }:

let
  cfg = config.deepwoods.apps.minecraft;
  modpack = pkgs.fetchPackwizModpack {
    url = "https://raw.githubusercontent.com/SonormaY/deepwoods/refs/heads/main/modules/minecraft/mc_fabric_pack/pack.toml";
    packHash = "sha256-GqYabwNz6vnvxR9mXwBq26RY0Qzl7cM0sBRkokuzmdo=";
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
          jre_headless = pkgs.jdk25_headless;
        };

        jvmOpts = "-Xms4G -Xmx4G -XX:+UseZGC -XX:+ZGenerational -XX:+AlwaysPreTouch";

        serverProperties = {
          server-port = 25565;
          difficulty = 3;
          motd="\\u00a7c\\u00a7l\\u00a7oS\\u00a71\\u00a7o\\u00a7lh\\u00a72\\u00a7o\\u00a7lu\\u00a73\\u00a7o\\u00a7ls\\u00a74\\u00a7o\\u00a7lh\\u00a75\\u00a7o\\u00a7lu\\u00a76\\u00a7o\\u00a7ln\\u00a77\\u00a7o\\u00a7lc\\u00a78\\u00a7o\\u00a7lh\\u00a79\\u00a7o\\u00a7ly\\u00a7a\\u00a7o\\u00a7lk \\u00a7b\\u00a7o\\u00a7lr\\u00a7c\\u00a7o\\u00a7le\\u00a7d\\u00a7o\\u00a7lt\\u00a7e\\u00a7o\\u00a7lu\\u00a7f\\u00a7o\\u00a7lr\\u00a71\\u00a7o\\u00a7ln\\u00a72\\u00a7o\\u00a7ls\\u00a73\\u00a7o\\u00a7l... \\u00a7f\\u00a7l\\u2620";
          gamemode = "survival";
          white-list = true;
          enforce-secure-profile=false;
          level-seed="58561304246185338";
          max-players=2;
        };

        whitelist = {
          sonormay = "724e39c4-9e55-40a8-9252-0a9170b4cf19";
        };

        symlinks = {
          "mods" = "${modpack}/mods";

          "server-icon.png" = ../minecraft/server-icon.png;
        };

        # files = {
        #   "config" = "${modpack}/config";
        # };
      };
    };
  };
}
