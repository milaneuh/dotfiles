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

  systemTools =
    (with pkgs; [
      bash-completion
      bashInteractive
      chezmoi
      curl
      gnupg
      openssh
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
    );

  shellTools =
    (with pkgs; [
      bat
      entr
      fd
      fzf
      jq
      ripgrep
      tmux
      tree
      yq-go
      zoxide
    ])
    ++ lib.optionals platform.isLinux [ pkgs.xclip ];

  fileManagerTools = with pkgs; [
    chafa
    ffmpegthumbnailer
    imagemagick
    pandoc
    ranger
  ];

  versionControlTools = with pkgs; [
    difftastic
    gh
    lazygit
  ];

  editorTools = with pkgs; [
    neovim
    tree-sitter
    universal-ctags
  ];

  formatters = with pkgs; [
    shfmt
    stylua
  ];

  linters = with pkgs; [
    hadolint
    lua51Packages.luacheck
    shellcheck
  ];

  languageServers = with pkgs; [
    bash-language-server
    docker-compose-language-service
    dockerfile-language-server
    gopls
    helm-ls
    jinja-lsp
    lemminx
    lua-language-server
    marksman
    pyright
    terraform-ls
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
  ];

  devopsTools = with pkgs; [
    k9s
  ];

  commandLineApplications = with pkgs; [
    claude-code
  ];
in
{
  inherit rangerArchives mermaid;

  common =
    systemTools
    ++ shellTools
    ++ fileManagerTools
    ++ versionControlTools
    ++ editorTools
    ++ formatters
    ++ linters
    ++ languageServers
    ++ devopsTools
    ++ commandLineApplications;

  host = with pkgs; [
    alacritty
    devpod
    nerd-fonts.jetbrains-mono
    ripdrag
  ];
}
