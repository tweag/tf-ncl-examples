let lib = import "./lib.ncl" in
let
  VolumeFormat = [| `QCow2 |]
  in
let
  volumeFormatToStr = fun x => switch {
    `QCow2 => "qcow2",
  } x
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
  } } | lib.addNameField
      | default = {},

  config | (import "./schema.ncl").Schema = lib.optionalRecord (lib.nonEmpty volumes) {
      resource."libvirt_volume" = lib.recordMap' (fun n vol => {
        "%{vol."sanitizedName__"}" = {
          name = n,
          pool = vol.pool,
        } & lib.optionalRecord (record.has_field "source" vol) {
          source = vol.source,
        } & lib.optionalRecord (record.has_field "format" vol) {
          format = volumeFormatToStr vol.format,
        } & lib.optionalRecord (record.has_field "base_volume" vol) {
          base_volume_id = config.resource."libvirt_volume"."%{vol.base_volume."sanitizedName__"}".id,
        } & lib.optionalRecord (record.has_field "size" vol) {
          size = vol.size,
        },
      }),
    },
}
