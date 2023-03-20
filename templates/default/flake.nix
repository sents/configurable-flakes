{
  description =
    "Some configurable flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.configurable-flakes.url = "github:sents/configurable-flakes";

  outputs = inputs@{ self, nixpkgs, flake-utils, configurable-flakes }:
    let
      lib = nixpkgs.lib;
    in
    configurable-flakes.lib.configurableFlake inputs
      {
        options = {
          systems = lib.mkOption {
            type = with lib.types; listOf (enum utils.allSystems);
            default = [ "aarch64-linux" "x86_64-linux"];
          };
          debug = lib.mkEnableOption "debug";
        };
      }
      ({ config, ... }:
        flake-utils.eachSystem config.systems (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            packages = import ./default.nix { inherit pkgs;
                                              debug = config.debug;
                                            };
          in
          { packages = packages // { default = packages.foo; }; }));
}
