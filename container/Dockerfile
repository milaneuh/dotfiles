FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

LABEL org.opencontainers.image.source="https://github.com/milaneuh/dotfiles"
LABEL org.opencontainers.image.description="Devcontainer base image with the dotfiles' Nix home-manager profile"

USER vscode
ENV USER=vscode

COPY --chown=vscode:vscode . /tmp/dotfiles

# Keep ~/.config/chezmoi/chezmoistate.boltdb: it records that the home-manager
# run_onchange script already ran, so containers skip it. Only the chezmoi.toml
# sourceDir pointer is stale once /tmp/dotfiles is gone.
RUN DEVPOD=true /tmp/dotfiles/install \
    && rm -rf /tmp/dotfiles "${HOME}/.config/chezmoi/chezmoi.toml"

ENV PATH="/home/vscode/.local/share/mise/shims:/home/vscode/.nix-profile/bin:${PATH}"

USER root

RUN echo "PATH=\"${PATH}\"" > /etc/environment \
    && echo /home/vscode/.nix-profile/bin/bash >> /etc/shells \
    && usermod --shell /home/vscode/.nix-profile/bin/bash vscode

USER vscode
