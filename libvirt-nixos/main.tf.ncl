{ nixos_image = "/nix/store/hv7l2m4zlrdwbvkjyk8l13hbx997wj0s-nixos-disk-image/nixos.img"
} & (
let
  PosNatMax = fun max l x =>
       contract.apply num.PosNat l x
    |> (fun x => if x > max
         then contract.blame_with "Value is larger than %{string.from max}" l
         else x)
  in
let v4_addresses = {
    subnet_prefix = "10.172.3",
    prefix_length = 24,

    endpoint |  PosNatMax 254 -> Str
      = fun x => "%{subnet_prefix}.%{string.from x}",
    
    subnet = "%{subnet_prefix}.0/%{string.from prefix_length}",
  } in
import "./libvirt.ncl" & {
  # TODO(vkleen): Record merging is broken in the presence of dictionaries, hardcode the image path until fixed
  nixos_image | Str
    = "/nix/store/8v70banam8nfd2xsamz0fxkcc9msp288-nixos-disk-image/nixos.img",

  networks."example" = {
    mode = `NAT,
    domain = "example.test",
    addresses = [ v4_addresses.subnet ],
    dhcp = true,
    dns.enable = true,
    dns.local_only = false,
  },

  volumes."nixos.img" = {
    source = nixos_image,
    format = `QCow2,
  },

  volumes."nixos" = {
    base_volume = volumes."nixos.img",
    size = 40 * 1024 * 1024 * 1024,
  },

  domains."nixos" = {
    memory = 4096,
    vcpu = 2,

    network_interfaces = [{
      network = networks."example",
      wait_for_lease = true,
      addresses = [ v4_addresses.endpoint 2 ],
    }],

    disks = [
      { volume = volumes."nixos" }
    ],

    consoles = [{
      type = `Pty,
      target_type = `Serial,
      target_port = "0",
    }],
  },

  config.output."ip".value = array.head (array.head domains."nixos".network_interfaces).addresses,
})
