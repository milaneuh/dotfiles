{
  lib,
  pkgs,
  role,
  ...
}:

let
  cliPlugin = package: name: "${package}/libexec/docker/cli-plugins/${name}";
in
lib.mkIf (role == "host" && pkgs.stdenv.hostPlatform.isDarwin) {
  home.packages = [ pkgs.docker-client ];

  home.file.".docker/cli-plugins/docker-compose".source = cliPlugin pkgs.docker-compose "docker-compose";
  home.file.".docker/cli-plugins/docker-buildx".source = cliPlugin pkgs.docker-buildx "docker-buildx";

  services.colima = {
    enable = true;
    profiles.default = {
      isActive = true;
      isService = true;
      setDockerHost = true;
      settings = {
        cpu = 4;
        disk = 60;
        memory = 6;
        mountType = "virtiofs";
        rosetta = true;
        vmType = "vz";
      };
    };
  };
}
