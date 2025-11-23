{
  lib,
  stdenv,
  dotnetCorePackages,
}:

let
  dotnetRuntime = dotnetCorePackages.runtime_8_0-bin;
  aspNetRuntime = dotnetCorePackages.aspnetcore_8_0-bin;
in

stdenv.mkDerivation rec {
  pname = "fluxpose";
  version = "1.0";

  src = ./fluxpose.zip;

  buildInputs = [
    dotnetRuntime
    aspNetRuntime
  ];

  # The archive unpacks into a 'net8.0' directory, which is handled automatically
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    # Create the destination directory for the application assets
    localAppDir="$out/lib/${pname}"
    mkdir -p $localAppDir

    # Copy all contents of the published 'net8.0' directory into the output
    # This preserves the required relative file structure (DLLs, JSONs, etc.)
    cp -r net8.0/* $localAppDir/

    # --- 3. Create the 'fluxpose' command wrapper ---
    mkdir -p $out/bin
    cat > $out/bin/fluxpose << EOF
    #!${stdenv.shell}/bin/bash

    # Set the path to the ASP.NET Core runtime to satisfy shared framework dependencies
    export DOTNET_ROOT=${aspNetRuntime}

    # Execute the application using the dotnet host and the application's entry-point DLL
    exec ${dotnetCorePackages.dotnet}/bin/dotnet $localAppDir/fluxpose.dll "\$@"
    EOF

    chmod +x $out/bin/fluxpose

    # --- Setup udev rules for the dock and dongle ---
    mkdir -p $out/lib/udev/rules.d
    cat > $out/lib/udev/rules.d/50-fluxpose-device.rules << EOF
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2FE3", ATTRS{idProduct}=="6856", MODE="0660", GROUP="plugdev"
    EOF
  '';

  meta = with lib; {
    description = "EMF based VR full body tracking runtime";
    homepage = "http://fluxpose.com";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
