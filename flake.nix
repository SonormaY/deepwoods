{
  description = "Deepwoods HomeLab Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, colmena, sops-nix, ... }@inputs: {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };

        epona =
          { name, nodes, pkgs, ... }:
          {
            deployment.targetHost = "192.168.50.2"; # Deploying locally for now
            deployment.targetUser = "sonorma";

            imports = [
              ./hosts/epona/default.nix
            ];
          };
      };
    };
}
