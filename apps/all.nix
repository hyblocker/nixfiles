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
    ./vscode.nix
  ];
}
