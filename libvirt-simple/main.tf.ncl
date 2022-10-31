let cfg = (import "./libvirt.ncl") & {
  networks."example" = {
    mode = `NAT,
    domain = "example.test",
    addresses = [ "10.172.3.0/24" ],
    dhcp = true,
    dns.enable = true,
    dns.local_only = false,
  },

  volumes."ubuntu22.10.qcow2" = {
    source = "https://cloud-images.ubuntu.com/kinetic/current/kinetic-server-cloudimg-amd64.img",
    format = `QCow2,
  },

  domains."ubuntu" = {
    memory = 4096,
    vcpu = 2,

    network_interfaces = [{
      network = networks."example",
      wait_for_lease = true,
      addresses = [ "10.17.3.2" ],
    }],

    disks = [
      { volume = volumes."ubuntu22.10.qcow2" }
    ],

    consoles = [{
      type = `Pty,
      target_type = `Serial,
      target_port = "0",
    }],
  },
} in
cfg.renderable_config
