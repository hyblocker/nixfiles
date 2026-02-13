# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{
  pkgs,
  inputs,
}:
{
  # example = pkgs.callPackage ./example { };
  hatter-icons = pkgs.callPackage ./icons/hatter-icons.nix { };
  fluxpose = pkgs.callPackage ./fluxpose { };
  sdvx7 = pkgs.callPackage ./sdvx7 { };
}
