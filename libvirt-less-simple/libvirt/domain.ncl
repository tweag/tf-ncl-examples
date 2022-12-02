let lib = import "./lib.ncl" in
{
  domains | {_: {
    memory | Num,
    vcpu | Num,

    network_interfaces | Array {
      network | lib.NamedRecord,
      hostname | Str
        | optional,
      wait_for_lease | Bool,
      addresses | Array Str,
    },

    disks | Array {
      volume | lib.NamedRecord,
    },

    consoles | Array {
      type | [| `Pty |],
      target_type | [| `Serial |],
      target_port | Str,
    },

    cloudinit | {
      config | default = {},
      rendered_config = m%"
      #cloud-config
      %{builtin.serialize `Yaml config}
      "%m,
    } | optional,
  } } | lib.addNameField
      | default = {},


  config | (import "./schema.ncl").Schema = lib.optionalRecord (lib.nonEmpty domains) {
    resource."libvirt_domain" = lib.recordMap' (fun n dom => {
      key = "%{dom.sanitizedName__}",
      value = {
        name = n,
        memory = dom.memory,
        network_interface = array.map (fun c => {
          network_id = config.resource."libvirt_network"."${c.network.sanitizedName__}".id,
          wait_for_lease = c.wait_for_lease,
          addresses = c.addresses,
        } & lib.optionalRecord (record.has_field "hostname" c) {
          hostname = c.hostname
        }) dom.network_interfaces,
      },
    }),
  },
}
