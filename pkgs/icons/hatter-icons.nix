{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  jdupes,
}:

let
  pname = "hatter-icon-theme";
in
stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2025-10-20";

  src = fetchFromGitHub {
    owner = "Mibea";
    repo = "Hatter";
    rev = "0b4dfa4f577ec2514562c56419386deda53c26da";
    hash = "sha256-K9T1L0nwJSCL+9ybGqcdRxQvFb/H84gYVLRQysqJyYQ=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  buildInputs = [ hicolor-icon-theme ];

  # These fixup steps are slow and unnecessary
  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    ./install.sh --dest $out/share/icons \
      --name Hatter 

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  # if we dont have these it'll fail with symlinks
  dontFixup = true;
  fixupPhase = "true";

  meta = with lib; {
    description = "Hatter - a modern and playful Linux icon theme";
    homepage = "https://github.com/Mibea/Hatter";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
