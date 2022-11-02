{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    tf-ncl.url = github:tweag/tf-ncl;
    utils.url = github:numtide/flake-utils;
  };

  outputs = { self, utils, tf-ncl, ... }@inputs: utils.lib.eachDefaultSystem (system: let
    pkgs = import inputs.nixpkgs {
      localSystem = { inherit system; };
      config = { };
      overlays = [ ];
    };

    providers = p: { inherit (p) libvirt; };

    terraform-with-plugins = tf-ncl.packages.${system}.terraform.withPlugins (p: pkgs.lib.attrValues (providers p));
    nickel = tf-ncl.packages.${system}.nickel;

    mkShellApp = body:
      utils.lib.mkApp { drv = pkgs.writeShellScriptBin "script.sh" body; };

    run-terraform = pkgs.writeShellScriptBin "terraform" ''
      set -e
      ln -sf ${self.ncl-schema.${system}} schema.ncl
      ${nickel}/bin/nickel export > main.tf.json <<EOF
        ((import "./main.tf.ncl") & { 
          nixos-image = "${self.nixosConfigurations.${system}.test.config.system.build.image}/nixos.img",
        }).renderable_config
      EOF
      ${terraform-with-plugins}/bin/terraform "$@"
    '';


  in rec {
    ncl-schema = tf-ncl.generateSchema.${system} providers;
    apps = {
      terraform = utils.lib.mkApp { drv = run-terraform; };
    };

    nixosConfigurations.test = inputs.nixpkgs.lib.nixosSystem {
      inherit pkgs system;
      modules = [
        "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"
        "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
        ({config, pkgs, lib, ...}: {
          config = {
            fileSystems."/" = {
              device = "/dev/disk/by-label/nixos";
              fsType = "ext4";
              autoResize = true;
            };

            boot = {
              growPartition = true;
              kernelParams = [ "console=ttyS0" ];
              loader.grub = {
                device = "/dev/vda";
                timeout = 0;
              };
            };

            services.openssh = {
              enable = true;
              passwordAuthentication = false;
            };

            networking.hostName = "nixos";

            system.build.image = import "${inputs.nixpkgs}/nixos/lib/make-disk-image.nix" {
              inherit lib config pkgs;
              diskSize = "auto";
              format = "raw";
            };
          };
        })
      ];
    };

    devShell = pkgs.mkShell {
      buildInputs = [
        run-terraform
        nickel
      ];
    };
  });
}
