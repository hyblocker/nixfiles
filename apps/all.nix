{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./browsers.nix
    ./core.nix
    ./discord
    ./vscode.nix
    ./steam.nix
  ];
}
