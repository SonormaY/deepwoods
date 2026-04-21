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
  };

  outputs = { self, nixpkgs, colmena, sops-nix, ... }@inputs:
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
          };
        };

        epona = {
          deployment = {
            targetHost = hosts.epona.ip;
            targetUser = hosts.epona.user;
            tags = hosts.epona.tags;
          };

          imports = [
            ./hosts/epona/configuration.nix
          ];
        };
      };
    };
}
