{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  hostname = config.networking.hostName;
  domain = "${hostname}.local";
  srv = config.services.forgejo.settings.server;
  forgejo_port = 3000;
in
{
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;

    stateDir = "/mnt/storage/forgejo";

    settings = {
      server = {
        DOMAIN = "git.${domain}";
        # ROOT_URL = "https://${srv.DOMAIN}/";
        ROOT_URL = "https://chungus.local:3000/";
        HTTP_PORT = forgejo_port;
        SSH_PORT = lib.head config.services.openssh.ports; # enable ssh
      };

      repository.ENABLE_PUSH_CREATE_USER = true;

      service.DISABLE_REGISTRATION = true;

      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };

  users.users.forgejo-runner = {
    isSystemUser = true;
    group = "forgejo-runner";
    extraGroups = [ "docker" ];
  };
  users.groups.forgejo-runner = {};

  # git runners
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "monolith";
      url = "https://${srv.DOMAIN}/";
      # Obtaining the path to the runner token file may differ
      # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
      tokenFile = config.sops.secrets."forgejo-runner-token".path;
      labels = [
        "ubuntu-latest:docker://node:16-bullseye"
        "ubuntu-22.04:docker://node:16-bullseye"
        "ubuntu-20.04:docker://node:16-bullseye"
        "ubuntu-18.04:docker://node:16-buster"
        "steam-sniper:docker://registry.gitlab.steamos.cloud/steamrt/sniper/sdk"
        ## optionally provide native execution on the host:
        # "native:host"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ forgejo_port ];

  lux.reverseProxy = {
    enable = true;

    services.git = {
      port = forgejo_port;
    };
  };
}