let lib = import "./lib.ncl" in
let
  NetworkMode = [| `NAT |]
  in
let
  networkModeToStr = fun x => switch {
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


  config | _push_default = lib.optionalRecord (lib.nonEmpty networks) {
    resource."libvirt_network" = lib.recordMap' (fun n net => {
      "%{net."sanitizedName__"}" = {
        name = n,
        mode = networkModeToStr net.mode,
        domain = net.domain,
        dhcp = [{
          enabled = net.dhcp,
        }],
        dns = [{
          enabled = net.dns.enable,
          local_only = net.dns.local_only,
        }],
      },
    }),
  },
}
