{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  jdupes,
}:

let
  pname = "hatterIcons";
in
stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "20.10.25"; # date i pulled on lol

  src = fetchFromGitHub {
    owner = "Mibea";
    repo = "Hatter";
    rev = "master";
    hash = "sha256-1169i75cll5lahc8iwy7pwajy5273nkim6ywzf5j09gh94pzbm1b";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  buildInputs = [
    hicolor-icon-theme
  ];

  # These fixup steps are slow and unnecessary
  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall
    ./install.sh --dest $out/share/icons
    jdupes --link-soft --recurse $out/share
    runHook postInstall
  '';

  meta = with lib; {
    description = "Hatter - a modern and playful Linux icon theme";
    homepage = "https://github.com/Mibea/Hatter";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
