{
  lib,
  pkgs,
  username,
  role,
  ...
}:

let
  packages = import ./packages.nix { inherit pkgs; };
  platform = pkgs.stdenv.hostPlatform;
in
{
  imports = [ ./containers.nix ];

  home.username = username;
  home.homeDirectory = if platform.isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  targets.genericLinux = {
    enable = platform.isLinux;
    gpu.enable = platform.isLinux && role == "host";
  };

  home.packages = packages.common ++ lib.optionals (role == "host") packages.host;

  xdg.configFile."ranger/plugins/ranger-archives".source = packages.rangerArchives;
  home.file.".tmux/plugins/tmux-fingers".source = "${pkgs.tmuxPlugins.fingers}/share/tmux-plugins/tmux-fingers";
  xdg.dataFile."nvim/mermaid.min.js".source = packages.mermaid;

  programs.mise = {
    enable = true;
    enableBashIntegration = false;
    enableMutableConfig = true;
    globalConfig = lib.optionalAttrs (role == "container") {
      settings.trusted_config_paths = [ "/workspaces" ];
    };
  };

  services.home-manager.autoExpire = {
    enable = true;
    timestamp = "-30 days";
    frequency = "weekly";
  };
}
