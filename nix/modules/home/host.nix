{
  # Desktop machines: GUI apps and media tooling.
  flake.modules.homeManager.host =
    { pkgs, ... }:
    {
      targets.genericLinux.gpu.enable = pkgs.stdenv.hostPlatform.isLinux;

      home.packages = with pkgs; [
        alacritty
        anki-bin
        chafa
        devpod
        ffmpegthumbnailer
        # terminfo collides with ncurses (both ship "ghostty"), ghostty-bin wins: it also has xterm-ghostty
        (lib.hiPrio (if stdenv.hostPlatform.isDarwin then ghostty-bin else ghostty))
        imagemagick
        nerd-fonts.jetbrains-mono
        obsidian
        pandoc
        ripdrag
      ];
    };
}
