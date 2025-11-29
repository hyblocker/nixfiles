{
  lib,
  stdenv,
  dotnetCorePackages,
  makeDesktopItem,
  pkgs,
  unzip,
}:

let
  aspNetRuntime = dotnetCorePackages.aspnetcore_8_0-bin;
  dotnet = dotnetCorePackages.dotnet_8;
in

stdenv.mkDerivation rec {
  pname = "fluxpose";
  version = "1.0";

  src = ./fluxpose.zip;

  nativeBuildInputs = [ unzip ];
  buildInputs = [ aspNetRuntime ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    localAppDir="$out/lib/${pname}"
    mkdir -p $localAppDir
    cp -r ./. $localAppDir/

    # Create the command wrappers
    mkdir -p $out/bin
    cat > $out/bin/fluxpose << EOF
    #!${stdenv.shell}
    export DOTNET_ROOT=${dotnet.runtime}/share/dotnet
    exec ${dotnet.runtime}/bin/dotnet $localAppDir/FluxPose_Master.dll "\$@"
    EOF

    cat > $out/bin/fluxpose-ui << EOF
    #!${stdenv.shell}
    export DOTNET_ROOT=${dotnet.aspnetcore}/share/dotnet
    exec ${dotnet.aspnetcore}/bin/dotnet $localAppDir/FluxPose_UI.dll "\$@"
    EOF

    chmod +x $out/bin/fluxpose
    chmod +x $out/bin/fluxpose-ui

    # Setup udev rules for the dock and dongle
    mkdir -p $out/lib/udev/rules.d
    cat > $out/lib/udev/rules.d/50-fluxpose-device.rules << EOF
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2FE3", ATTRS{idProduct}=="6856", MODE="0660", GROUP="plugdev"
    EOF
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "fluxpose";
      desktopName = "Fluxpose";
      comment = "EMF Full body tracking";
      icon = "fluxpose";
      exec = "fluxpose-ui";
      terminal = false;
      categories = [
        "Utility"
        "Application"
      ];
    })
  ];

  meta = with lib; {
    description = "EMF based VR full body tracking runtime";
    homepage = "http://fluxpose.com";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
