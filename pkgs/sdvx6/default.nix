{
  lib,
  pkgs ? import <nixpkgs> { },
  refreshRate ? 60, # Default value is 60Hz
}:

let
  pname = "sdvx6";
  version = "2025120900";

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "sdvx6";
      desktopName = "Sound Voltex EXCEED GEAR";
      exec = "sdvx6";
      icon = "controller";
      categories = [ "Game" ];
    })
    (pkgs.makeDesktopItem {
      name = "sdvx6-config";
      desktopName = "SDVX Config (SpiceCfg)";
      exec = "sdvx6 --config";
      icon = "settings";
      categories = [ "Settings" ];
    })
    (pkgs.makeDesktopItem {
      name = "sdvx6-asphyxia";
      desktopName = "Asphyxia Core (SDVX Server)";
      exec = "sdvx6 --server";
      icon = "network-server";
      categories = [ "Utility" ];
    })
  ];

  part1 = pkgs.requireFile {
    name = "KFC-2025120900.7z.001";
    sha256 = "sha256-RYB7zBqKKtATKNrzeU/WZxY1gx3kRZCEdizTjbvJZU8=";
    message = "Add part 1: nix-store --add-fixed sha256 KFC-2025120900.7z.001";
  };

  part2 = pkgs.requireFile {
    name = "KFC-2025120900.7z.002";
    sha256 = "sha256-Bak4ak4S5St0xeAEI/j3SlUNkeiBTF8iYDaphrcUE9A=";
    message = "Add part 2: nix-store --add-fixed sha256 KFC-2025120900.7z.002";
  };

  asphyxiaSrc = pkgs.fetchzip {
    url = "https://github.com/asphyxia-core/asphyxia-core.github.io/releases/download/v1.50d/asphyxia-core-linux-x64.zip";
    sha256 = "sha256-w6Ft8zyuTXU8eW7w1QrzO+O7vaTVe3iqtfKF4uThmlY=";
    stripRoot = false;
  };

  kfcPlugin = pkgs.fetchzip {
    url = "https://github.com/22vv0/asphyxia_plugins/releases/download/kfc-6.2.3/kfc-6.2.3.zip";
    sha256 = "sha256-sr7AxRf+qz32vkrqd8BN+dIZYd9Dl+JbSuprnme+Jp0=";
    stripRoot = false;
  };

  spiceSrc = pkgs.fetchzip {
    url = "https://github.com/spice2x/spice2x.github.io/releases/download/25-12-31/spice2x-25-12-31-full.zip";
    sha256 = "sha256-ZCZeSw64fLMW5dS1sHEMlf5NHPcuM6I5fFr4TwyQIZo=";
    stripRoot = true;
  };

  gameData = pkgs.stdenv.mkDerivation {
    name = "${pname}-data-${version}";
    srcs = [
      part1
      part2
    ];
    nativeBuildInputs = [ pkgs.p7zip ];
    unpackPhase = ''
      mkdir archive_stage extract_stage
      ln -s ${part1} archive_stage/${part1.name}
      ln -s ${part2} archive_stage/${part2.name}

      echo "Extracting 20GB+ game data..."

      7z x archive_stage/${part1.name} -oextract_stage -y > /dev/null &
      Z_PID=$!

      while kill -0 $Z_PID 2>/dev/null; do
        SIZE=$(du -sh extract_stage | cut -f1)
        echo "Extracting game data, extracted $SIZE"
        sleep 5
      done

      wait $Z_PID
      echo "Extraction complete"

      mkdir -p $out

      # If archive has exactly one top-level dir, flatten it
      TOPLEVEL=$(find extract_stage -mindepth 1 -maxdepth 1 | wc -l)
      if [ "$TOPLEVEL" -eq 1 ] && [ -d "$(find extract_stage -mindepth 1 -maxdepth 1)" ]; then
        TOPDIR=$(find extract_stage -mindepth 1 -maxdepth 1)
        echo "Flattening $TOPDIR"
        cp -a "$TOPDIR"/. "$out"/
      else
        echo "Archive already flat"
        cp -a extract_stage/. "$out"/
      fi
    '';
    installPhase = "true";
  };
in
pkgs.buildFHSEnv {
  inherit pname;
  name = "${pname}-${version}";

  targetPkgs =
    pkgs: with pkgs; [
      glibcLocales
      winetricks
      wineWowPackages.full
      wineasio
      vulkan-loader
      vulkan-tools
      nodejs
      p7zip
      niri
      jq
      libGL
      pipewire.jack
      alsa-lib
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.lndir
      fontconfig
      noto-fonts-cjk-sans
      ipafont
      ffmpeg
      libva
      libva-utils
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
    ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    ${pkgs.lib.concatMapStrings (item: ''
      cp ${item}/share/applications/* $out/share/applications/
    '') desktopItems}
  '';

  runScript = pkgs.writeShellScript "sdvx-launcher" ''
    # for better compat temporarily set locale to japan
    export LANG="ja_JP.UTF-8"
    export LC_ALL="ja_JP.UTF-8"
    export SDVX_HOME="$HOME/.local/share/sdvx-arcade"
    export SPICECFGPATH="$SDVX_HOME/spicetools.xml"
    export PULSE_LATENCY_MSEC=37
    export WINEARCH="win64"
    export WINEPREFIX="$SDVX_HOME/wine"
    export WINEDLLOVERRIDES="dxgi,d3d9=n,b,d3d11=n,b,mfplat=n,b,evr=n,b"
    export WINEDEBUG=-all
    export DXVK_STATE_CACHE=1
    export DXVK_LOG_LEVEL=none
    export GST_PLUGIN_SYSTEM_PATH_1_0="${pkgs.gst_all_1.gstreamer.out}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0"

    if ! command -v wine64 >/dev/null; then
      echo "ERROR: wine64 not found"
      exit 1
    fi

    # setup game shit
    mkdir -p "$SDVX_HOME/game/modules"
    lndir -silent "${gameData}" "$SDVX_HOME/game"
    cp -f "${spiceSrc}/extras/linux/spice64.exe" "$SDVX_HOME/game/"
    cp -f "${spiceSrc}/extras/linux/spicecfg.exe" "$SDVX_HOME/game/"
    cp -f "${spiceSrc}/stubs/64/"*.dll "$SDVX_HOME/game/modules/"

    if [ ! -d "$SDVX_HOME/asphyxia" ]; then
      echo "Initializing mutable Asphyxia directory..."
      mkdir -p "$SDVX_HOME/asphyxia"
      mkdir -p "$SDVX_HOME/asphyxia/savedata"
      cp -a "${asphyxiaSrc}/." "$SDVX_HOME/asphyxia/"
      chmod -R u+rwX "$SDVX_HOME/asphyxia"
    fi

    if [ ! -d "$SDVX_HOME/asphyxia/plugins/sdvx@asphyxia" ]; then
      echo "Installing KFC plugin..."
      chown -R $USER:$USER "$SDVX_HOME/asphyxia/plugins"
      chmod -R u+rwX "$SDVX_HOME/asphyxia/plugins"
      cp -a "${kfcPlugin}/." "$SDVX_HOME/asphyxia/plugins/sdvx@asphyxia/"
      chmod -R u+rwX "$SDVX_HOME/asphyxia/plugins/sdvx@asphyxia"
      mkdir -p "$SDVX_HOME/asphyxia/plugins/sdvx@asphyxia"
    fi

    if [ ! -d "$WINEPREFIX" ]; then
      echo "Setting up Wine prefix..."
      wineboot --init
      
      echo "Installing d3dcompiler..."
      winetricks -q d3dcompiler_43 d3dcompiler_46 d3dcompiler_47
      echo "Installing DXVK..."
      winetricks -q dxvk
      echo "Installing vkd3d..."
      winetricks -q vkd3d
      echo "Installing d3d9..."
      winetricks -q d3dx9 d3dx9_24 d3dx9_25 d3dx9_26 d3dx9_27 d3dx9_28 d3dx9_29 d3dx9_30 d3dx9_31 d3dx9_32 d3dx9_33 d3dx9_34 d3dx9_35 d3dx9_36 d3dx9_37 d3dx9_38 d3dx9_39 d3dx9_40 d3dx9_41 d3dx9_42 d3dx9_43
      echo "Installing fonts..."
      winetricks -q cjkfonts

      # wine64 reg add 'HKCU\Software\Wine\DllOverrides' /v dxgi /d native /f > /dev/null 2>&1
      # wine64 reg add 'HKCU\Software\Wine\DllOverrides' /v d3d9 /d native /f > /dev/null 2>&1
      # wine64 reg add 'HKCU\Software\Wine\DllOverrides' /v d3d11 /d native /f > /dev/null 2>&1

      # setup WineASIO
      WINEASIO64_SO="${pkgs.wineasio}/lib/wine/x86_64-unix/wineasio64.dll.so"
      DEST64="$WINEPREFIX/drive_c/windows/system32/wineasio64.dll"
      ln -sf "$WINEASIO64_SO" "$DEST64"
      wine64 regsvr32 /s "C:\windows\system32\wineasio64.dll"

      WINEASIO32_SO="${pkgs.wineasio}/lib/wine/i386-unix/wineasio32.dll.so"
      DEST32="$WINEPREFIX/drive_c/windows/syswow64/wineasio32.dll"
      ln -sf "$WINEASIO32_SO" "$DEST32"
      wine regsvr32 /s "C:\windows\syswow64\wineasio32.dll"

      # fonts required for Live2D
      # wine64 reg add "HKCU\Software\Wine\Fonts\Replacements" /v "MS Gothic" /d "IPAGothic" /f
      # wine64 reg add "HKCU\Software\Wine\Fonts\Replacements" /v "MS PGothic" /d "IPAPGothic" /f
      # wine64 reg add "HKCU\Software\Wine\Fonts\Replacements" /v "MS UI Gothic" /d "IPAGothic" /f
    fi

    # script may invoke either asphyxia, spicecfg or the game
    if [[ "$1" == "--server" ]]; then
      echo "Starting Asphyxia Core only..."
      cd "$SDVX_HOME/asphyxia"
      ./asphyxia-core
    elif [[ "$1" == "--winecfg" ]]; then
      echo "Starting winecfg..."
      cd "$SDVX_HOME/game"
      pw-jack winecfg
    elif [[ "$1" == "--regedit" ]]; then
      echo "Starting regedit..."
      cd "$SDVX_HOME/game"
      wine64 regedit
    elif [[ "$1" == "--winetricks" ]]; then
      echo "Starting winetricks..."
      cd "$SDVX_HOME/game"
      winetricks dlls list
    elif [[ "$1" == "--wineasio" ]]; then
      echo "Starting wineasio-settings..."
      cd "$SDVX_HOME/game"
      pw-jack wineasio-settings
    elif [[ "$1" == "--config" ]]; then
      echo "Starting Spice Configuration..."
      cd "$SDVX_HOME/game"
      wine64 spicecfg.exe -cfgpath $SPICECFGPATH
    else
      # Launch game
      MONITOR=$(niri msg -j outputs | jq -r 'keys | .[0]')
      ORIG_WIDTH=$(niri msg -j outputs | jq -r ".\"$MONITOR\".modes[0].width")
      ORIG_HEIGHT=$(niri msg -j outputs | jq -r ".\"$MONITOR\".modes[0].height")
      ORIG_RATE=$(niri msg -j outputs | jq -r ".\"$MONITOR\".modes[0].refresh_rate")

      restore_display() {
        niri msg output "$MONITOR" transform normal
        niri msg output "$MONITOR" mode "''${ORIG_WIDTH}x''${ORIG_HEIGHT}@''${ORIG_RATE}"
      }

      niri msg output "$MONITOR" transform 90
      niri msg output "$MONITOR" mode 1920x1080@${toString (refreshRate * 1000)}

      cd "$SDVX_HOME/asphyxia"
      ./asphyxia-core > /dev/null 2>&1 &
      ASPHYXIA_PID=$!
      sleep 5

      echo "Launching SDVX EXCEED GEAR..."
      cd "$SDVX_HOME/game"
      # pipe output into iconv as the game dumps CP932 (win32 Shift-JIS) to make the output utf8 and readable in terminal
      pw-jack wine64 spice64.exe -cfgpath $SPICECFGPATH 2>&1 | iconv -f cp932 -t utf-8 -c &
      WINE_PID=$!

      # tell niri sdvx needs fullscreen
      echo "Waiting for game window to map..."
      MAX_RETRIES=30
      COUNT=0
      while [ $COUNT -lt $MAX_RETRIES ]; do
          GAME_WINDOW_ID=$(niri msg -j windows | jq '.[] | select(.app_id == "spice64.exe") | .id' 2>/dev/null)

          if [ -n "$GAME_WINDOW_ID" ]; then
              echo "Found game window (ID: $GAME_WINDOW_ID). Forcing fullscreen..."
              niri msg action focus-window --id "$GAME_WINDOW_ID"
              niri msg action fullscreen-window
              break
          fi

          sleep 1
          ((COUNT++))
      done

      wait $WINE_PID

      # game closed, kill asphyxia and restore displays
      kill $ASPHYXIA_PID
      restore_display
    fi
  '';
}
