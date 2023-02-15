let Aws = import "./types.ncl" in
{
  aws.region | Aws.Region,

  aws.credentials | {
    profile
      | Str
      | optional,
    assume_role
      | {
        role_arn | Str,
        session_name
          | Str
          | default = "tf-ncl",
      }
      | optional,
  },

  config.provider.aws = [{
    region = string.from aws.region,
  } & (
    if record.has_field "profile" aws.credentials
    then { profile = aws.credentials.profile }
    else {}
  ) & (
    if record.has_field "assume_role" aws.credentials
    then {
      assume_role = [{
        role_arn = aws.credentials.assume_role.role_arn,
        session_name = aws.credentials.assume_role.session_name,
      }]
    }
    else {}
  )],
}
