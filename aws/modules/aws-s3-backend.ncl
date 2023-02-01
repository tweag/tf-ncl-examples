let Aws = import "./types.ncl" in
{
  aws.state | {
    bucket | Str,
    key | Str,
    region | Aws.Region,
  },

  config.terraform.backend.s3 = {
    bucket = aws.state.bucket,
    key = aws.state.key,
    region = string.from aws.state.region,
  },
}
