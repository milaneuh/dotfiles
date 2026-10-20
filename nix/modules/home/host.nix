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
        imagemagick
        nerd-fonts.jetbrains-mono
        obsidian
        pandoc
        ripdrag
      ];
    };
}
