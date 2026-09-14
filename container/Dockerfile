FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

USER vscode
ENV USER=vscode

COPY --chown=vscode:vscode . /tmp/dotfiles

RUN DEVPOD=true /tmp/dotfiles/install \
    && rm -rf /tmp/dotfiles "${HOME}/.config/chezmoi"

USER root

RUN echo /home/vscode/.nix-profile/bin/bash >> /etc/shells \
    && usermod --shell /home/vscode/.nix-profile/bin/bash vscode

USER vscode
