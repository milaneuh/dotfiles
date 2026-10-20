{
  # Devcontainers and VMs: mise must trust the mounted workspace, and there
  # is no GPU to wrap (genericLinux would otherwise enable it by default).
  flake.modules.homeManager.container = {
    targets.genericLinux.gpu.enable = false;
    programs.mise.globalConfig.settings.trusted_config_paths = [ "/workspaces" ];
  };
}
