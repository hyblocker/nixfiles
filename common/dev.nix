{
  config,
  pkgs,
  lib,
  ...
}:

{
  # add dev stuff
  users.users.lux.packages = with pkgs; [
    clang-tools
    llvmPackages.libcxxClang
    llvmPackages.stdenv
    lld
    cmake
    ninja
  ];
}
