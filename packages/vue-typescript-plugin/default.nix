{
  lib,
  buildNpmPackage,
  nix-update-script,
}:
buildNpmPackage {
  pname = "vue-typescript-plugin";
  version = "3.2.6";

  src = ./.;

  # Run `nix build` once; replace with the hash from the error message.
  npmDepsHash = lib.fakeHash;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vue-typescript-plugin
    cp -r node_modules/@vue/typescript-plugin/. $out/lib/vue-typescript-plugin/
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
}
