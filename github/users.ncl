let User = import "./user-contract.ncl" in
{
  vkleen = {
    is-admin = false,
    extra-teams = [ "nickel" ],
  },
  yannham = {
    is-admin = true,
    extra-teams = [ "nickel" ],
  },
  rando = {},
} | {_: User}
