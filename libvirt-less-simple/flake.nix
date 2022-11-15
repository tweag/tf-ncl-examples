{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    tf-ncl.url = github:tweag/tf-ncl;
    utils.url = github:numtide/flake-utils;
  };

  outputs = { self, utils, tf-ncl, ... }@inputs: utils.lib.eachDefaultSystem (system: let
    pkgs = import inputs.nixpkgs {
      localSystem = { inherit system; };
      config = { };
      overlays = [ ];
    };

    providers = p: { inherit (p) libvirt local cloudinit; };

    terraform-with-plugins = tf-ncl.packages.${system}.terraform.withPlugins (p: pkgs.lib.attrValues (providers p));
    nickel = tf-ncl.packages.${system}.nickel;

    run-terraform = pkgs.writeShellScriptBin "terraform" ''
      set -e
      ln -sf ${self.ncl-schema.${system}} schema.ncl
      ${nickel}/bin/nickel export > main.tf.json <<EOF
        (import "./main.tf.ncl").renderable_config
      EOF
      ${terraform-with-plugins}/bin/terraform "$@"
    '';
  in {
    ncl-schema = tf-ncl.generateSchema.${system} providers;
    apps = {
      terraform = utils.lib.mkApp { drv = run-terraform; };
    };
    devShell = pkgs.mkShell {
      buildInputs = [
        run-terraform
        nickel
      ];
    };
  });
}
