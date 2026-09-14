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
        }
        {
          system = "aarch64-linux";
          username = "vscode";
        }
        {
          system = "x86_64-linux";
          username = "vscode";
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
            extraSpecialArgs = { inherit (machine) username; };
            modules = [ ./home.nix ];
          };
        }) machines
      );

      devShells = nixpkgs.lib.genAttrs systems (system: {
        default = (pkgsFor system).mkShell {
          packages = (import ./packages.nix { pkgs = pkgsFor system; }).commandLine;
        };
      });
    };
}
