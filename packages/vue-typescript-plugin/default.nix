{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs_22,
  pnpm_8,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
}:
let
  pnpm' = pnpm_8.override { nodejs = nodejs_22; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vue-typescript-plugin";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "vuejs";
    repo = "language-tools";
    tag = "v${finalAttrs.version}";
    # Run `nix build` once; replace with the hash from the error message.
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    nodejs_22
    pnpmConfigHook
    pnpm'
  ];

  buildInputs = [ nodejs_22 ];

  pnpmWorkspaces = [ "@vue/typescript-plugin" ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pnpmWorkspaces
      pname
      src
      version
      ;
    pnpm = pnpm';
    fetcherVersion = 1;
    # Run `nix build` once; replace with the hash from the error message.
    hash = lib.fakeHash;
  };

  buildPhase = ''
    runHook preBuild

    pnpm --filter "@vue/typescript-plugin..." build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vue-typescript-plugin
    cp -r packages/typescript-plugin/{dist,package.json} $out/lib/vue-typescript-plugin/
    cp -r node_modules $out/lib/vue-typescript-plugin/

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Official Vue.js TypeScript plugin for IDEs";
    homepage = "https://github.com/vuejs/language-tools";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
