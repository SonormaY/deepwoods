# flake.nix
{
  description = "Deepwoods HomeLab Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    colmena.url = "github:zhaofengli/colmena";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = { self, nixpkgs, colmena, sops-nix, nix-minecraft, ... }@inputs:
    let
      hosts = import ./hosts.nix;
    in
    {
      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = [ colmena.packages.x86_64-linux.colmena ];
      };

      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [ inputs.nix-minecraft.overlay ];
          };
        };

        epona = {
          deployment = {
            targetHost = hosts.epona.ip;
            targetPort = hosts.epona.port;
            targetUser = hosts.epona.user;
            tags = hosts.epona.tags;
          };

          imports = [
            ./hosts/epona/configuration.nix
            inputs.sops-nix.nixosModules.sops
            inputs.nix-minecraft.nixosModules.minecraft-servers
          ];
        };
      };
    };
}
