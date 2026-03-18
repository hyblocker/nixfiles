{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../services/utils.nix
    ../../services/dns.nix
    ../../services/filebrowser.nix
    ../../services/immich.nix
    ../../services/code-server.nix
  ];
}
