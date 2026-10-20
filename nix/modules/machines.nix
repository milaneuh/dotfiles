{ self, inputs, lib, ... }:

let
  hostModules = with self.modules.homeManager; [
    base
    packages
    host
    docker
  ];

  containerModules = with self.modules.homeManager; [
    base
    packages
    container
  ];

  machines = {
    "milan-aarch64-darwin" = {
      system = "aarch64-darwin";
      username = "milan";
      modules = hostModules;
    };
    "milan.rougemont-aarch64-darwin" = {
      system = "aarch64-darwin";
      username = "milan.rougemont";
      modules = hostModules;
    };
    "vscode-aarch64-linux" = {
      system = "aarch64-linux";
      username = "vscode";
      modules = containerModules;
    };
    "vscode-x86_64-linux" = {
      system = "x86_64-linux";
      username = "vscode";
      modules = containerModules;
    };
  };

  mkHome =
    _name:
    { system, username, modules }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit username; };
      inherit modules;
    };
in
{
  flake.homeConfigurations = lib.mapAttrs mkHome machines;
}
