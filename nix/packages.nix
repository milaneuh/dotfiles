{ pkgs }:

let
  neovimWithMagick = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
    (pkgs.neovimUtils.makeNeovimConfig {
      extraLuaPackages = ps: [ ps.magick ];
    })
    // {
      wrapRc = false;
    }
  );

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

  whisperModels = pkgs.linkFarm "whisper-cpp-models" [
    {
      name = "share/whisper-cpp/models/ggml-small-q5_1.bin";
      path = pkgs.fetchurl {
        url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small-q5_1.bin";
        hash = "sha256-roXkqTXXpWe9EC/lWvwWu1lb22GOEbL8dZG8CBIEEbs=";
      };
    }
    {
      name = "share/whisper-cpp/models/ggml-silero-v6.2.0.bin";
      path = pkgs.fetchurl {
        url = "https://huggingface.co/ggml-org/whisper-vad/resolve/main/ggml-silero-v6.2.0.bin";
        hash = "sha256-KqJpt4XutTqCmDogUB3ffB2cSOM6tjpBORrGyff7aYc=";
      };
    }
  ];

  pythonWithTkinterForScripts = pkgs.python3.withPackages (ps: [
    ps.pip
    ps.tkinter
  ]);

  systemTools = with pkgs; [
    alsa-utils
    bash-completion
    curl
    gnupg
    openssh
    sshfs
    stow
  ];

  shellTools = with pkgs; [
    bat
    entr
    fzf
    jq
    pass
    rclone
    ripgrep
    sshpass
    tmux
    tree
    xclip
    zoxide
  ];

  documentTools = [
    whisperModels
  ]
  ++ (with pkgs; [
    ffmpeg
    imagemagick
    mermaid-cli
    pandoc
    pdf2svg
    tesseract
    typst
    whisper-cpp
  ]);

  fileManagerTools = with pkgs; [
    ffmpegthumbnailer
    ranger
    ripdrag
  ];

  versionControlTools = with pkgs; [
    difftastic
    lazygit
  ];

  editorTools = [
    neovimWithMagick
  ]
  ++ (with pkgs; [
    tree-sitter
    universal-ctags
  ]);

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
    ++ languageRuntimes
    ++ commandLineApplications;

  graphical = with pkgs; [
    anki
    chromium
    flameshot
    gimp
    gnome-extension-manager
    inkscape
    joplin-desktop
    kitty
    mpv
    vlc
    xournalpp
  ];

  gnomeShellExtensions = [
    pkgs.gnome49Extensions."forge@jmmaranan.com"
    pkgs.gnome49Extensions."gnome-shell-go-to-last-workspace@github.com"
    pkgs.gnome49Extensions."rounded-window-corners@fxgn"
  ];
}
