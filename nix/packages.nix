{ pkgs }:

let
  inherit (pkgs) lib;
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
  inherit rangerArchives mermaid;

  common =
    (with pkgs; [
      bash-completion
      bash-language-server
      bashInteractive
      bat
      chezmoi
      claude-code
      curl
      difftastic
      docker-compose-language-service
      dockerfile-language-server
      entr
      fd
      fzf
      gh
      git
      gnupg
      gopls
      hadolint
      helm-ls
      jinja-lsp
      jq
      k9s
      lazygit
      lemminx
      lua-language-server
      lua51Packages.luacheck
      marksman
      neovim
      openssh
      pyright
      ranger
      ripgrep
      shellcheck
      shfmt
      stylua
      terraform-ls
      tmux
      tree
      tree-sitter
      typescript-language-server
      universal-ctags
      vscode-langservers-extracted
      yaml-language-server
      yq-go
      zoxide
    ])
    ++ lib.optionals platform.isDarwin (
      with pkgs;
      [
        coreutils
        findutils
        gawk
        gnugrep
        gnused
        gnutar
        ncurses
      ]
    )
    ++ lib.optionals platform.isLinux [ pkgs.xclip ];

  host = with pkgs; [
    alacritty
    chafa
    devpod
    ffmpegthumbnailer
    imagemagick
    nerd-fonts.jetbrains-mono
    pandoc
    ripdrag
  ];
}
