let Tf = import "./schema.ncl" in
let users' = import "./users.ncl" in
let { mk_teams, mk_memberships, .. } = import "./lib.ncl" in
{
  users = users',

  config = {
    terraform.required_providers = Tf.required_providers,
  }
  & mk_memberships users
  & mk_teams config users,
}
| Tf.Config
