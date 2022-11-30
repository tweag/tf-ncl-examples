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
      inherit (p) cloudflare digitalocean tls;
    };

    terraform-with-plugins = inputs.tf-ncl.packages.${system}.terraform.withPlugins (p: pkgs.lib.attrValues (providers p));
    nickel = inputs.nickel.packages.${system}.default;

    mkShellApp = body:
      utils.lib.mkApp { drv = pkgs.writeShellScriptBin "script.sh" body; };

    run-terraform = pkgs.writeShellScriptBin "terraform" ''
      set -e
      ln -sf ${self.ncl-schema.${system}} schema.ncl
      ${nickel}/bin/nickel export > main.tf.json <<EOF
        (import "./main.tf.ncl").renderable_config
      EOF
      ${terraform-with-plugins}/bin/terraform "$@"
    '';


  in rec {
    ncl-schema = inputs.tf-ncl.generateSchema.${system} providers;
    apps = {
      default = apps.terraform;
      terraform = utils.lib.mkApp { drv = run-terraform; };
    };

    packages = {
      default = packages.terraform;
      terraform = run-terraform;
    };

    devShell = pkgs.mkShell {
      buildInputs = [
        run-terraform
        nickel
      ];
    };
  });
}
