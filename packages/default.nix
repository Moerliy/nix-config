# Custom (overlay) packages not available in nixpkgs.
#
# Usage:
#   nixpkgs.overlays = [ (import ./packages) ];
#
# Then reference packages as e.g. pkgs.vue-typescript-plugin.
final: _prev: {
  vue-typescript-plugin = final.callPackage ./vue-typescript-plugin { };
}
