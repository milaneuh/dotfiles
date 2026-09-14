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
        arch = "host";
        runtime = "docker";
        modelRunner = "docker";
        hostname = null;
        kubernetes = {
          enabled = false;
          version = "v1.35.0+k3s1";
          k3sArgs = [ "--disable=traefik" ];
          port = 0;
        };
        autoActivate = true;
        network = {
          address = false;
          mode = "shared";
          interface = "en0";
          preferredRoute = false;
          dns = [ ];
          dnsHosts = {
            "host.docker.internal" = "host.lima.internal";
          };
          hostAddresses = false;
          gatewayAddress = "192.168.5.2";
        };
        forwardAgent = false;
        docker = { };
        vmType = "vz";
        portForwarder = "ssh";
        rosetta = true;
        binfmt = true;
        nestedVirtualization = false;
        mountType = "virtiofs";
        mountInotify = false;
        cpuType = "host";
        provision = [ ];
        sshConfig = true;
        sshPort = 0;
        mounts = [ ];
        diskImage = "";
        forceDiskImage = false;
        rootDisk = 20;
        env = { };
      };
    };
  };
}
