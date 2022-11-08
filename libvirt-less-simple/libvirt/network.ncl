let lib = import "./lib.ncl" in
let
  NetworkMode = [| `NAT |]
  in
let
  network_mode_to_str = fun x => switch {
    `NAT => "nat",
  } x
  in
{
  networks | {_: {
    mode | NetworkMode,
    domain | Str,
    addresses | Array Str,
    dhcp | Bool,
    dns | {
      enable | Bool,
      local_only | Bool,
    },
  } } | lib.addNameField,


  config | _push_default = lib.optionalRecord (lib.non_empty networks) {
    resource."libvirt_network" = lib.recordMap' (fun n net => {
      "%{net."__sanitized_name"}" = {
        name = n,
        mode = network_mode_to_str net.mode,
        domain = c.domain,
        dhcp = [{
          enabled = c.dhcp,
        }],
        dns = [{
          enabled = c.dns.enable,
          local_only = c.dns.local_only,
        }],
      },
    }),
  },
}
