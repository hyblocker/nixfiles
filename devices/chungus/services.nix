{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../services/homelab_utils.nix
    ../../services/filebrowser.nix
    ../../services/immich.nix
    ../../services/code-server.nix
  ];
}
