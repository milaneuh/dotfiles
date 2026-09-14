{
  description = "User environment, pinned through flake.lock";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      machines = [
        {
          system = "aarch64-darwin";
          username = "milan";
          role = "host";
        }
        {
          system = "aarch64-linux";
          username = "vscode";
          role = "container";
        }
        {
          system = "x86_64-linux";
          username = "vscode";
          role = "container";
        }
      ];

      systems = nixpkgs.lib.unique (map (machine: machine.system) machines);

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      homeConfigurations = builtins.listToAttrs (
        map (machine: {
          name = "${machine.username}-${machine.system}";
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgsFor machine.system;
            extraSpecialArgs = { inherit (machine) username role; };
            modules = [ ./home.nix ];
          };
        }) machines
      );

      devShells = nixpkgs.lib.genAttrs systems (system: {
        default = (pkgsFor system).mkShell {
          packages = (import ./packages.nix { pkgs = pkgsFor system; }).common;
        };
      });
    };
}
