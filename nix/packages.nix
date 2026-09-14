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

  pythonWithTkinterForScripts = pkgs.python3.withPackages (ps: [
    ps.pip
    ps.tkinter
  ]);

  expertReleases = {
    aarch64-darwin = {
      asset = "expert_darwin_arm64";
      hash = "sha256-Gj2pB81H1m1g76Yr1vnrC/8q8jrrbxNM/RKKoCPewB4=";
    };
    aarch64-linux = {
      asset = "expert_linux_arm64";
      hash = "sha256-hT+uiZ5T3ulpwJ69ryYrgg0WhYLYSomch7ELHyH2p2g=";
    };
    x86_64-linux = {
      asset = "expert_linux_amd64";
      hash = "sha256-99WQW8PwmxKNSUHHdpYz8tEIvmN/Io7kMentE30sVWM=";
    };
  };

  expert = pkgs.stdenvNoCC.mkDerivation {
    pname = "expert";
    version = "0.1.9";

    src = pkgs.fetchurl {
      url = "https://github.com/expert-lsp/expert/releases/download/v0.1.9/${expertReleases.${platform.system}.asset}";
      inherit (expertReleases.${platform.system}) hash;
    };

    dontUnpack = true;
    installPhase = "install -Dm755 $src $out/bin/expert";
  };

  systemTools = with pkgs; [
    bash-completion
    chezmoi
    curl
    gnupg
    openssh
  ];

  shellTools =
    (with pkgs; [
      bat
      entr
      fzf
      jq
      ripgrep
      tmux
      tree
      zoxide
    ])
    ++ lib.optionals platform.isLinux [ pkgs.xclip ];

  documentTools = with pkgs; [
    ffmpeg
    imagemagick
    mermaid-cli
    pandoc
    pdf2svg
  ];

  fileManagerTools = with pkgs; [
    chafa
    ffmpegthumbnailer
    ranger
    ripdrag
  ];

  versionControlTools = with pkgs; [
    difftastic
    lazygit
  ];

  editorTools = with pkgs; [
    neovim
    tree-sitter
    universal-ctags
  ];

  formatters = with pkgs; [
    black
    prettier
    shfmt
    stylua
  ];

  linters = with pkgs; [
    djlint
    eslint_d
    lua51Packages.luacheck
    revive
    shellcheck
  ];

  languageServers = [
    expert
  ]
  ++ (with pkgs; [
    bash-language-server
    gopls
    jinja-lsp
    lemminx
    lua-language-server
    marksman
    pyright
    typescript-language-server
    vscode-langservers-extracted
  ]);

  languageRuntimes = [
    pkgs.go
    pythonWithTkinterForScripts
  ];

  commandLineApplications = with pkgs; [
    claude-code
  ];
in
{
  inherit rangerArchives mermaid;

  commandLine =
    systemTools
    ++ shellTools
    ++ documentTools
    ++ fileManagerTools
    ++ versionControlTools
    ++ editorTools
    ++ formatters
    ++ linters
    ++ languageServers
    ++ languageRuntimes
    ++ commandLineApplications;

  graphical = with pkgs; [
    alacritty
  ];
}
