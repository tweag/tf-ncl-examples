let lib = import "./lib.ncl" in
let Tf = import "./schema.ncl" in
let users' = import "./users.ncl" in
let { mk_teams, mk_memberships, .. } = {
  collect_teams = fun users => ["all"] @ (
    users
    |> record.values
    |> array.map (fun user => user.extra-teams)
    |> array.flatten
    |> lib.uniq ),

  collect_users = fun users team =>
    users
    |> record.fields
    |> array.filter (fun user =>
      team == "all" || array.elem team users."%{user}".extra-teams),

  mk_teams = fun config users =>
    users
    |> collect_teams
    |> array.map (fun team => {
      resource.github_team."%{team}-team" = {
        name = team,
        privacy = "closed",
      },
      resource.github_team_members."%{team}-members" = {
        team_id = config.resource.github_team."%{team}-team".id,
        members = collect_users users team
          |> array.map (fun user => {
            username = user,
            role = if users."%{user}".is-admin
              then "maintainer"
              else "member",
          }),
      },
    })
    |> array.foldl (&) {},

  mk_memberships = fun users =>
    users
    |> record.fields
    |> array.map (fun name =>
      let user = users."%{name}" in
      {
        resource.github_membership."%{name}" = {
          role = if user.is-admin then "admin" else "member",
          username = name,
        }
      } 
    )
    |> array.foldl (&) {}
}
in
{
  users = users',

  config = {
    terraform.required_providers = Tf.required_providers,
  }
  & mk_memberships users
  & mk_teams config users,
}
| Tf.Config
