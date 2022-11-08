let lib = import "./lib.ncl" in
let
  VolumeFormat = [| `QCow2 |]
  in
let
  volume_format_to_str = switch {
    `QCow2 = "qcow2",
  }
  in
{
  volumes | {_: {
    pool | Str
      | default = "default",
    source | Str
      | optional,
    format | VolumeFormat
      | optional,
    base_volume | lib.NamedRecord
      | optional,
    size | Num
      | optional,
  } } | lib.addNameField,

  config | (import "./schema.ncl").Configuration
    | _push_default = lib.optionalRecord (lib.non_empty networks) {
      resource."libvirt_volume" = lib.recordMap' (fun n vol => {
        "%{lib.sanitize n}" = {
          name = n,
          pool = vol.pool,
        } & lib.optionalRecord (record.has_field "source" vol) {
          source = vol.source,
        } & lib.optionalRecord (record.has_field "format" vol) {
          format = volume_format_to_str vol.format,
        } & lib.optionalRecord (record.has_field "base_volume" vol) {
          base_volume_id = config.resource."libvirt_volume"."%{lib.sanitize vol.base_volume."__name"}".id,
        } & lib.optionalRecord (record.has_field "size" vol) {
          size = vol.size,
        },
      }),
    },
}
