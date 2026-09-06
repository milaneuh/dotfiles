{
  config,
  lib,
  pkgs,
  nixgl,
  username,
  ...
}:

let
  packages = import ./packages.nix { inherit pkgs; };
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  targets.genericLinux = {
    enable = true;
    nixGL.packages = nixgl.packages;
    nixGL.defaultWrapper = "mesa";
  };

  home.packages =
    packages.commandLine
    ++ packages.gnomeShellExtensions
    ++ map config.lib.nixGL.wrap packages.graphical;

  xdg.configFile."ranger/plugins/ranger-archives".source = packages.rangerArchives;
  xdg.dataFile."nvim/mermaid.min.js".source = packages.mermaid;

  home.sessionVariables.ALSA_PLUGIN_DIR = "${pkgs.pipewire}/lib/alsa-lib";

  systemd.user.services.home-manager-expire = {
    Unit.Description = "Expire home-manager generations older than 30 days";
    Service = {
      Type = "oneshot";
      Environment = [
        "PATH=${
          lib.makeBinPath [
            pkgs.coreutils
            pkgs.gnugrep
            pkgs.gnused
          ]
        }:/nix/var/nix/profiles/default/bin"
      ];
      ExecStart = "${config.home.profileDirectory}/bin/home-manager expire-generations '-30 days'";
    };
  };

  systemd.user.timers.home-manager-expire = {
    Unit.Description = "Weekly expiry of home-manager generations";
    Timer = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
