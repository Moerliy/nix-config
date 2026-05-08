{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "1.0";

  amber = fetchurl {
    url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/${version}/hypr_Bibata-Modern-Amber.tar.gz";
    hash = "sha256-BVbAb58KvOKhOmBXZfgef24ayovSDCQ21dtNtNM2pX0=";
  };

  classic = fetchurl {
    url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/${version}/hypr_Bibata-Modern-Classic.tar.gz";
    hash = "sha256-+ZXnbI3bBLcb0nv2YW3eM/tK4dsraNM4UAO9BpSqfXk=";
  };

  ice = fetchurl {
    url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/${version}/hypr_Bibata-Modern-Ice.tar.gz";
    hash = "sha256-3ttG6Hnr9TPtvIiIbQrsSodu5iZV4Y62xaKvQmkdLPg=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "bibata-hyprcursor-modern";
  inherit version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons/Bibata-Modern-Amber-Hyprcursor"
    tar -xzf ${amber} -C "$out/share/icons/Bibata-Modern-Amber-Hyprcursor"

    mkdir -p "$out/share/icons/Bibata-Modern-Classic-Hyprcursor"
    tar -xzf ${classic} -C "$out/share/icons/Bibata-Modern-Classic-Hyprcursor"

    mkdir -p "$out/share/icons/Bibata-Modern-Ice-Hyprcursor"
    tar -xzf ${ice} -C "$out/share/icons/Bibata-Modern-Ice-Hyprcursor"

    runHook postInstall
  '';

  meta = {
    description = "Bibata Hyprcursor modern flavors (Amber, Classic, Ice)";
    homepage = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
