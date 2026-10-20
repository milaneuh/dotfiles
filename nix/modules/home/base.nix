{
  # Shared by every machine: identity, home-manager itself, and the files
  # that are fetched rather than packaged.
  flake.modules.homeManager.base =
    { pkgs, username, ... }:
    let
      platform = pkgs.stdenv.hostPlatform;

      rangerArchives = pkgs.fetchFromGitHub {
        owner = "maximtrp";
        repo = "ranger-archives";
        rev = "0b1cfa9a77412c3b51da5b1b213c672227f9fbb4";
        hash = "sha256-HEJ+8KlG++PK0vVpEYptbyuPZAKllX5PeyaTBKcf+8M=";
      };

      mermaid = pkgs.fetchurl {
        url = "https://cdn.jsdelivr.net/npm/mermaid@11.17.2/dist/mermaid.min.js";
        hash = "sha256-WB7X10vZBI0OOpE2OSfXLvIpQtdyJUayf3zCnjU5Drg=";
      };
    in
    {
      home.username = username;
      home.homeDirectory = if platform.isDarwin then "/Users/${username}" else "/home/${username}";
      home.stateVersion = "26.05";

      programs.home-manager.enable = true;

      targets.genericLinux.enable = platform.isLinux;

      xdg.configFile."ranger/plugins/ranger-archives".source = rangerArchives;
      home.file.".tmux/plugins/tmux-fingers".source = "${pkgs.tmuxPlugins.fingers}/share/tmux-plugins/tmux-fingers";
      xdg.dataFile."nvim/mermaid.min.js".source = mermaid;

      programs.mise = {
        enable = true;
        enableBashIntegration = false;
        enableMutableConfig = true;
      };

      services.home-manager.autoExpire = {
        enable = true;
        timestamp = "-30 days";
        frequency = "weekly";
      };
    };
}
