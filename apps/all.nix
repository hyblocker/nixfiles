{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./helium.nix
    ./firefox.nix
    ./core.nix
    ./discord
    ./vscode.nix
    ./steam.nix
  ];
}
