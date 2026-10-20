let
  # Shared by every machine and by `nix develop`.
  commonFor =
    pkgs:
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
    ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
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
    ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.xclip ];
in
{
  flake.modules.homeManager.packages = { pkgs, ... }: { home.packages = commonFor pkgs; };

  perSystem = { pkgs, ... }: { devShells.default = pkgs.mkShell { packages = commonFor pkgs; }; };
}
