let Tf = import "./schema.ncl" in
let recordMap' #: forall a b. (Str -> a -> {_: b}) -> {_: a} -> {_: b}
      = fun f r => array.fold
          (fun n acc => acc & (f n r."%{n}"))
          {}
          (record.fields r)
  in
let sanitize : Str -> Str
      = string.replace_regex "(\\.)" "-"
  in
let addNameField = fun l x =>
      x |> record.map (fun name r => r & { "__name" | force = "%{name}" })
  in
{
  networks | { _: {
    mode | [| `NAT |],
    domain | Str,
    addresses | Array Str,
    dhcp | Bool,
    dns | {
      enable | Bool,
      local_only | Bool,
    },
  }} | addNameField,

  volumes | { _: {
    pool | Str
      | default = "default",
    source | Str,
    format | [| `QCow2 |],
  }} | addNameField,

  domains | { _: {
    memory | Num,
    vcpu | Num,

    network_interfaces | Array {
      network | {"__name" | Str, ..},
      wait_for_lease | Bool,
      addresses | Array Str,
    },

    disks | Array {
      volume | {"__name" | Str, ..},
    },

    consoles | Array {
      type | [| `Pty |],
      target_type | [| `Serial |],
      target_port | Str,
    },
  }} | addNameField,

  config | Tf.Configuration
    | default = {
      provider.libvirt = [
        { uri = "qemu:///session" }
      ],

      resource."libvirt_network" = recordMap' (fun n c => {
          "%{sanitize n}" = {
            name = n,
            mode = switch {
              `NAT => "nat"
            } c.mode,
            domain = c.domain,
            addresses = c.addresses,
            dhcp = [{
              enabled = c.dhcp,
            }],
            dns = [{
              enabled = c.dns.enable,
              local_only = c.dns.local_only,
            }],
          }
        }) networks,

      resource."libvirt_volume" = recordMap' (fun n c => {
          "%{sanitize n}" = {
            name = n,
            pool = c.pool,
            source = c.source,
            format = switch {
              `QCow2 => "qcow2"
            } c.format,
          }
        }) volumes,

      resource."libvirt_domain" = recordMap' (fun n c => {
          "%{sanitize n}" = {
            name = n,
            memory = c.memory,
            vcpu = c.vcpu,
            network_interface = array.map (fun c => {
              network_id = resource."libvirt_network"."%{sanitize c.network."__name"}".id,
              wait_for_lease = c.wait_for_lease,
              addresses = c.addresses,
            }) c.network_interfaces,
            disk = array.map (fun c => {
              volume_id = resource."libvirt_volume"."%{sanitize c.volume."__name"}".id,
              scsi = true,
              file = "",
              block_device = "",
              url = "",
              wwn = "",
            }) c.disks,
            console = array.map (fun c => {
              type = switch {
                `Pty => "pty"
              } c.type,
              target_type = switch {
                `Serial => "serial"
              } c.target_type,
              target_port = c.target_port,
            }) c.consoles,
          }
      }) domains,
    },
  renderable_config | default = Tf.mkConfig config,
}
