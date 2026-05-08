{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "1.0";

  amber = fetchurl {
    url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/${version}/hypr_Bibata-Original-Amber.tar.gz";
    hash = "sha256-WTXiuRje6VJlVDayvI9GzvKYNjdgXYqKRi8t2QRanDk=";
  };

  classic = fetchurl {
    url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/${version}/hypr_Bibata-Original-Classic.tar.gz";
    hash = "sha256-y4yRJYTI9uf/sbIJxwi0bZxgsiAXykn253qgDkHZa7g=";
  };

  ice = fetchurl {
    url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/${version}/hypr_Bibata-Original-Ice.tar.gz";
    hash = "sha256-J24W7tr4hilpV6DWl1xKafFrCHjhrcwubN06xcRs4ts=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "bibata-hyprcursor-original";
  inherit version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons/Bibata-Original-Amber-Hyprcursor"
    tar -xzf ${amber} -C "$out/share/icons/Bibata-Original-Amber-Hyprcursor"

    mkdir -p "$out/share/icons/Bibata-Original-Classic-Hyprcursor"
    tar -xzf ${classic} -C "$out/share/icons/Bibata-Original-Classic-Hyprcursor"

    mkdir -p "$out/share/icons/Bibata-Original-Ice-Hyprcursor"
    tar -xzf ${ice} -C "$out/share/icons/Bibata-Original-Ice-Hyprcursor"

    runHook postInstall
  '';

  meta = {
    description = "Bibata Hyprcursor original flavors (Amber, Classic, Ice)";
    homepage = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
