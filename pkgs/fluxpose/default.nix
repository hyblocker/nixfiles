{
  lib,
  stdenv,
  dotnetCorePackages,
  copyDesktopItems,
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

  nativeBuildInputs = [
    copyDesktopItems
    unzip
    pkgs.imagemagick
  ];
  buildInputs = [
    aspNetRuntime
    pkgs.libusb1
    pkgs.glib
    pkgs.webkitgtk_4_1
    pkgs.gtk3
    pkgs.libnotify
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    localAppDir="$out/lib/${pname}"
    mkdir -p $localAppDir
    cp -r ./. $localAppDir/

    # wwwroot is the webcache, needs to be mutable so symlink it
    # mkdir -p "\$HOME/.cache/fluxpose/wwwroot"
    # WWWROOT_PATH="$localAppDir/wwwroot"

    # Create the command wrappers
    mkdir -p $out/bin
    cat > $out/bin/fluxpose << EOF
    #!${stdenv.shell}
    export DOTNET_ROOT=${dotnet.runtime}/share/dotnet
    export LD_LIBRARY_PATH="${pkgs.libusb1}/lib:\$LD_LIBRARY_PATH"
    cd $localAppDir
    exec ${dotnet.runtime}/bin/dotnet $localAppDir/FluxPose_Master.dll "\$@"
    EOF

    cat > $out/bin/fluxpose-ui << EOF
    #!${stdenv.shell}
    export DOTNET_ROOT=${dotnet.aspnetcore}/share/dotnet
    export PATH="${dotnet.runtime}/bin:\$PATH"
    export LD_LIBRARY_PATH="${pkgs.libusb1}/lib:${pkgs.webkitgtk_4_1}/lib:${pkgs.gtk3}/lib:${pkgs.glib.out}/lib:${pkgs.libnotify}/lib:$localAppDir/runtimes/linux-x64/native:\$LD_LIBRARY_PATH"
    cd $localAppDir
    exec ${dotnet.aspnetcore}/bin/dotnet $localAppDir/FluxPose_UI.dll "\$@"
    EOF

    chmod +x $out/bin/fluxpose
    chmod +x $out/bin/fluxpose-ui

    # icon is provided as an ico file, use imagemagick to convert it to varying pngs
    ICON_FILE="$localAppDir/favicon.ico"
    ICON_SIZES="16 24 32 48 64 128 256"
    mkdir -p $out/share/icons/hicolor

    for SIZE in $ICON_SIZES; do
        ICON_DIR="$out/share/icons/hicolor/''${SIZE}x''${SIZE}/apps"
        install -d "$ICON_DIR"
        convert "$ICON_FILE[0]" -resize "''${SIZE}x''${SIZE}" "$ICON_DIR/fluxpose.png"
    done

    # Setup udev rules for the dock and dongle
    mkdir -p $out/lib/udev/rules.d
    cat > $out/lib/udev/rules.d/50-fluxpose-device.rules << EOF
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2FE3", ATTRS{idProduct}=="6856", MODE="0660", GROUP="plugdev"
    EOF

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "fluxpose";
      exec = "fluxpose-ui";
      icon = "fluxpose";
      desktopName = "Fluxpose";
      genericName = "Fluxpose";
      comment = "EMF Full body tracking";
      categories = [
        "Utility"
        "Application"
      ];
    })
  ];

  meta = with lib; {
    description = "EMF based VR full body tracking runtime";
    homepage = "http://fluxpose.com";
    license = lib.licenses.unfreeRedistributable;
    platforms = platforms.linux;
    mainProgram = "fluxpose-ui";
  };
}
