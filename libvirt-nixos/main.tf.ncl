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
  nixos-image | Str,

  networks."example" = {
    mode = `NAT,
    domain = "example.test",
    addresses = [ v4_addresses.subnet ],
    dhcp = true,
    dns.enable = true,
    dns.local_only = false,
  },

  domains."nixos" = {
    memory = 4096,
    vcpu = 2,

    network_interfaces = [{
      network = networks."example",
      wait_for_lease = true,
      addresses = [ v4_addresses.endpoint 2 ],
    }],
  },

  config.output."nixos-image".value = nixos-image,
}
