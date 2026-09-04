{
  description = "User environment, pinned through flake.lock";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixgl,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "mtholomier";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit nixgl username; };
        modules = [ ./home.nix ];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = (import ./packages.nix { inherit pkgs; }).commandLine;
      };
    };
}
