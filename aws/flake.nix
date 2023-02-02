{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nickel.url = github:tweag/nickel;
    tf-ncl.url = github:tweag/tf-ncl;
    utils.url = github:numtide/flake-utils;
  };

  outputs = { self, utils, ... }@inputs: utils.lib.eachDefaultSystem (system: let
    pkgs = import inputs.nixpkgs {
      localSystem = { inherit system; };
      config = { };
      overlays = [ ];
    };

    providers = p: {
      inherit (p) aws null external;
    };

    terraform-with-plugins = inputs.tf-ncl.packages.${system}.terraform.withPlugins (p: pkgs.lib.attrValues (providers p));
    nickel = inputs.nickel.packages.${system}.default;

    run-terraform = pkgs.writeShellScriptBin "terraform" ''
      set -e
      ln -sf ${self.packages.${system}.ncl-schema} schema.ncl
      ${nickel}/bin/nickel export > main.tf.json <<EOF
        (import "./main.tf.ncl").renderable_config
      EOF
      ${terraform-with-plugins}/bin/terraform "$@"
    '';


  in rec {
    apps = {
      default = apps.terraform;
      terraform = utils.lib.mkApp { drv = run-terraform; };
    };

    packages = {
      default = packages.terraform;
      terraform = run-terraform;
      ncl-schema = inputs.tf-ncl.generateSchema.${system} providers;
    };

    devShell = pkgs.mkShell {
      buildInputs = [
        run-terraform
        nickel
      ];
    };
  });
}
