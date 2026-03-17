{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../services/filebrowser
    ../../services/immich
    ../../services/code-server
  ];
}
