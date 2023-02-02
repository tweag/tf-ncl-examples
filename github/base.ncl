let infra = import "./terraform.ncl" in
infra & {
  users | infra.Users
    = {
      vkleen = {
        is-admin = false,
        extra-teams = [ "nickel" ],
      },
      yannham = {
        is-admin = true,
        extra-teams = [ "nickel" ],
      },
    }
}
