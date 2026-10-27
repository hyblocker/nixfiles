{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./chromium.nix
    ./firefox.nix
    ./core.nix
    ./discord
    ./vscode.nix
    ./steam.nix
  ];
}
