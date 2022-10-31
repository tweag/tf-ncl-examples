let Tf = import "./schema.ncl" in
let recordMap' #: forall a b. (Str -> a -> {_: b}) -> {_: a} -> {_: b}
      = fun f r => array.fold
          (fun n acc => acc & (f n r."%{n}"))
          {}
          (record.fields r)
  in
let optionalRecord
      = fun b r => if b then r else {}
  in
let non_empty
      = fun r => array.length (record.fields r) != 0
  in
let sanitize : Str -> Str
      = string.replace_regex "(\\.)" "-"
  in
let addNameField = fun l x =>
      x |> record.map (fun name r => r & { "__name" | force = "%{name}" })
  in
let NamedRecord = { "__name" | Str, .. }
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
  }} 
    | addNameField,

  volumes | { _: {
    pool | Str
      | default = "default",
    source | Str
      | optional,
    format | [| `QCow2 |]
      | optional,
    base_volume | NamedRecord
      | optional,
    size | Num
      | optional,
  }}
    | addNameField,

  domains | { _: {
    memory | Num,
    vcpu | Num,

    network_interfaces | Array {
      network | NamedRecord,
      hostname | Str
        | optional,
      wait_for_lease | Bool,
      addresses | Array Str,
    },

    disks | Array {
      volume | NamedRecord,
    },

    consoles | Array {
      type | [| `Pty |],
      target_type | [| `Serial |],
      target_port | Str,
    },

    cloudinit | {
      config | default = {},
      rendered_config | default = m%"
      #cloud-config
      %{builtin.serialize `Yaml config}
      "%m,
    } | optional,

  }}
    | addNameField,

  config | Tf.Configuration
    | default = {
      provider.libvirt = [
        { uri = "qemu:///session" }
      ],
    } & optionalRecord (non_empty networks) {
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
    } & optionalRecord (non_empty volumes) {
      resource."libvirt_volume" = recordMap' (fun n c => {
          "%{sanitize n}" = {
            name = n,
            pool = c.pool,
          } & (optionalRecord (record.has_field "source" c) {
            source = c.source
          }) & (optionalRecord (record.has_field "format" c) {
            format = switch {
              `QCow2 => "qcow2"
            } c.format,
          }) & (optionalRecord (record.has_field "base_volume" c) {
            base_volume_id = config.resource."libvirt_volume"."%{sanitize c.base_volume."__name"}".id,
          }) & (optionalRecord (record.has_field "size" c) {
            size = c.size,
          }),
        }) volumes,
    } & optionalRecord (non_empty domains) {
      resource."libvirt_domain" = recordMap' (fun n c => {
          "%{sanitize n}" = {
            name = n,
            memory = c.memory,
            vcpu = c.vcpu,
            network_interface = array.map (fun c => {
              network_id = config.resource."libvirt_network"."%{sanitize c.network."__name"}".id,
              wait_for_lease = c.wait_for_lease,
              addresses = c.addresses,
            } & (optionalRecord (record.has_field "hostname" c) {
              hostname = c.hostname,
            })) c.network_interfaces,
            disk = array.map (fun c => {
              volume_id = config.resource."libvirt_volume"."%{sanitize c.volume."__name"}".id,
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
          } & (optionalRecord (record.has_field "cloudinit" c) {
            cloudinit = config.resource."libvirt_cloudinit_disk"."__cloudinit-%{sanitize n}".id,
          })
        }) domains,
    } & (optionalRecord (array.any (fun r => record.has_field "cloudinit" r) (record.values domains)) {
      resource."libvirt_cloudinit_disk" = 
        (recordMap' (fun n c =>
          optionalRecord (record.has_field "cloudinit" c)
          {
            "__cloudinit-%{sanitize n}" = {
              name = "__cloudinit-%{n}",
              user_data = c.cloudinit.rendered_config,
            }
          }
        ) domains),
    }),
  renderable_config | default = Tf.mkConfig config,
}