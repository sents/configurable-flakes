{
  description = "Provides a method to define flakes depending on parameters using the nixpkgs module/option system";

  inputs = {
    nixpkgs-lib.url = "github:NixOS/nixpkgs/nixos-unstable?dir=lib";
  };

  outputs = { self, nixpkgs-lib}: {
    lib = import ./lib.nix { lib=nixpkgs-lib.lib; };
    templates.default = {
      path = ./templates/default;
      description = "Template for a flake using configurable-flakes with flake-utils";
    };
  };
}
