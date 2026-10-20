{ inputs, ... }:

{
  # Declares `flake.modules.<class>.<name>` — the dendritic module namespace.
  imports = [ inputs.flake-parts.flakeModules.modules ];

  # Systems the per-system outputs (devShells) are built for.
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];
}
