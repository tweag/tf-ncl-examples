{
  cloud_init : {
    hostname: Str,
    kube_version: Str,
    ssh_pubkey: Str,
  } -> Str,
  cloud_init = fun args => let
    cfg = {
      hostname = args.hostname,
      users = [
        {
          name = "ubuntu",
          sudo = "ALL=(ALL) NOPASSWD:ALL",
          ssh_authorized_keys = [
            args.ssh_pubkey
          ],
        }
      ],
      growpart = {
        mode = "auto",
        devices = [ "/" ],
      },
    } in 
  m%"
  #cloud-config
  %{builtin.serialize `Yaml (cfg | Dyn)}
  "%m,
}
