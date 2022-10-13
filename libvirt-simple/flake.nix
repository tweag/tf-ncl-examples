{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    tf-ncl.url = github:tweag/terraform-contracts;
    utils.url = github:numtide/flake-utils;
  };

  outputs = { self, utils, tf-ncl, ... }@inputs: utils.lib.eachDefaultSystem (system: let
    pkgs = import inputs.nixpkgs {
      localSystem = { inherit system; };
      config = { };
      overlays = [ ];
    };

    providers = p: with p; [ libvirt ];

    terraform-with-plugins = tf-ncl.packages.${system}.terraform.withPlugins providers;
    nickel = tf-ncl.packages.${system}.nickel;

    run-terraform = pkgs.writeShellScriptBin "terraform" ''
      set -e
      ln -sf ${self.ncl-schema.${system}} schema.ncl
      ${nickel}/bin/nickel -f main.tf.ncl export > main.tf.json
      ${terraform-with-plugins}/bin/terraform "$@"
    '';
  in {
    ncl-schema = tf-ncl.schemas.${system}.libvirt; #TODO(vkleen): use generateSchema
    pass = {
      terraform = utils.mkApp { drv = run-terraform; };
    };
    devShell = pkgs.mkShell {
      buildInputs = [
        run-terraform
        nickel
      ];
    };
  });
}
