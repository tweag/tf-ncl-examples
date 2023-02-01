let Utils = import "../utils.ncl" in
let Aws = import "./types.ncl" in
{
  aws.availability_zones
    | {_: {
      region | Aws.Region,
      data,
      path,
    }}
    | Utils.Elaborate "data" (fun name => config.data.aws_availability_zones."%{name}")
    | Utils.Elaborate "path" (fun name => m%"data.aws_availability_zones.%{name}"%),

  config = aws.availability_zones |> record.fields |> array.map (fun name => let
    cfg = aws.availability_zones."%{name}"
  in {
    data.aws_availability_zones."%{name}" = {
      state = "available",
    },
  }) |> Utils.merge_array,
}