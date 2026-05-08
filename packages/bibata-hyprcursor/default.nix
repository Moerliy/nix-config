{
  lib,
  stdenvNoCC,
  fetchurl,
  zstd,
}:
let
  version = "v1.0.0";

  amber = fetchurl {
    url = "https://github.com/rtgiskard/bibata_cursor/releases/download/${version}/Bibata-Modern-Amber.hypr.tar.zst";
    hash = "sha256-KLJobO8kXI/LG9uVOuCDUPbDWnWN2Yp0Hp8yPN1GpxM=";
  };

  classic = fetchurl {
    url = "https://github.com/rtgiskard/bibata_cursor/releases/download/${version}/Bibata-Modern-Classic.hypr.tar.zst";
    hash = "sha256-t/T9LZ1DGvqyad924xwrZuDJnoi8+Jvu6X0dE0hFsPE=";
  };

  ice = fetchurl {
    url = "https://github.com/rtgiskard/bibata_cursor/releases/download/${version}/Bibata-Modern-Ice.hypr.tar.zst";
    hash = "sha256-oTjUc8kdN7vVQ+7SEVLlyZCMXzCfGEwbmuP/NWbKMOQ=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "bibata-hyprcursor-modern";
  inherit version;
  nativeBuildInputs = [ zstd ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons/Bibata-Modern-Amber-Hyprcursor"
    tar --use-compress-program=unzstd -xf ${amber} -C "$out/share/icons/Bibata-Modern-Amber-Hyprcursor"

    mkdir -p "$out/share/icons/Bibata-Modern-Classic-Hyprcursor"
    tar --use-compress-program=unzstd -xf ${classic} -C "$out/share/icons/Bibata-Modern-Classic-Hyprcursor"

    mkdir -p "$out/share/icons/Bibata-Modern-Ice-Hyprcursor"
    tar --use-compress-program=unzstd -xf ${ice} -C "$out/share/icons/Bibata-Modern-Ice-Hyprcursor"

    runHook postInstall
  '';

  meta = {
    description = "Bibata Hyprcursor modern flavors (Amber, Classic, Ice)";
    homepage = "https://github.com/rtgiskard/bibata_cursor";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
