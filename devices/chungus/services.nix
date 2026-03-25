{
  config,
  pkgs,
  ...
}:

{
  imports = [
    # utils
    ../../services/utils.nix
    # custom dns, required to access web apps as we inject custom CNAME records to redirect local domains to reverse-proxy
    ../../services/dns.nix

    # storage
    ../../services/samba.nix

    # web apps
    ../../services/filebrowser.nix
    ../../services/immich.nix
    ../../services/code-server.nix
    ../../services/forgejo.nix
  ];
}
