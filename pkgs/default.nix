# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{
  pkgs,
  inputs,
}:
{
  # example = pkgs.callPackage ./example { };
  hatterIcons = pkgs.callPackage ./icons/hatter-icons.nix { };
}
