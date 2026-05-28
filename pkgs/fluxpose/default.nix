{
  lib,
  stdenv,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  pkgs,
  unzip,
  wrapGAppsHook3,
}:

let
  aspNetRuntime = dotnetCorePackages.aspnetcore_8_0-bin;
  dotnet = dotnetCorePackages.dotnet_8;
in

stdenv.mkDerivation rec {
  pname = "fluxpose";
  version = "1.0";

  src = pkgs.requireFile {
    name = "fluxpose.zip";
    sha256 = "sha256-H/jy9oP+eFmAaAMAhMEFivA0jow8Q684NoQl2JvtTvE=";
    message = "Add fluxpose to store: nix-store --add-fixed sha256 fluxpose.zip";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    pkgs.gst_all_1.gstreamer
    copyDesktopItems
    unzip
    pkgs.imagemagick
    pkgs.patchelf
  ];
  buildInputs = with pkgs; [
    aspNetRuntime
    libusb1
    glib
    webkitgtk_4_1
    gtk3
    libnotify
    glib-networking
  ];

  runtimeDeps = with pkgs; [
    # GTK and WebKit for Photino.NET WebView
    gtk3
    webkitgtk_4_1

    # X11 libraries for window management
    libX11
    libxrandr
    libxi
    libxcursor
    libxdamage
    libxfixes
    libxcomposite
    libxext
    libxrender

    # Core GTK dependencies
    glib
    pango
    cairo
    atk
    gdk-pixbuf

    # Desktop integration
    libnotify
    dbus

    # GStreamer for WebKit media support (videos, audio)
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav

    # WebKit networking/SSL support (for loading images over HTTPS)
    glib-networking
    libsoup_3
    cacert

    # usb for fluxpose
    libusb1
  ];

  dontConfigure = true;
  dontWrapGApps = false;
  dontBuild = true;

  # Additional wrapper arguments for NixOS compatibility
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.coreutils
          pkgs.bash
        ]
      }
      --set SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    )
  '';

  installPhase = ''
    runHook preInstall

    patchelf \
      --replace-needed libwebkit2gtk-4.0.so.37 libwebkit2gtk-4.1.so \
      --replace-needed libjavascriptcoregtk-4.0.so.18 libjavascriptcoregtk-4.1.so.0 \
      ./runtimes/linux-x64/native/Photino.Native.so

    patchelf \
      --replace-needed libwebkit2gtk-4.0.so.37 libwebkit2gtk-4.1.so \
      --replace-needed libjavascriptcoregtk-4.0.so.18 libjavascriptcoregtk-4.1.so.0 \
      ./runtimes/linux-arm64/native/Photino.Native.so

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
    export LD_LIBRARY_PATH="$localAppDir/runtimes/linux-x64/native:${pkgs.webkitgtk_4_1}/lib:${pkgs.gtk3}/lib:${pkgs.glib.out}/lib:${pkgs.libnotify}/lib:\$LD_LIBRARY_PATH"
    cd $localAppDir
    exec ${dotnet.runtime}/bin/dotnet $localAppDir/FluxPose_Master.dll "\$@"
    EOF

    # ui calls server via .exe; this fixes that
    cat > $localAppDir/FluxPose_Master.exe << EOF
    #!/bin/sh
    exec ${dotnet.runtime}/bin/dotnet $localAppDir/FluxPose_Master.dll "$@"
    EOF
    chmod +x $localAppDir/FluxPose_Master.exe

    cat > $out/bin/fluxpose-ui << EOF
    #!${stdenv.shell}
    export DOTNET_ROOT=${dotnet.aspnetcore}/share/dotnet
    export PATH="${dotnet.runtime}/bin:\$PATH"
    export LD_LIBRARY_PATH="$localAppDir/runtimes/linux-x64/native:${pkgs.webkitgtk_4_1}/lib:${pkgs.gtk3}/lib:${pkgs.glib.out}/lib:${pkgs.libnotify}/lib:\$LD_LIBRARY_PATH"
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
