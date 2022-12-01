{
  networks."example" = {
    mode = `NAT,
    domain = "example.test",
    addresses = [ "10.17.3.0/24" ],
    dhcp = true,
    dns.enable = true,
    dns.local_only = false,
  },

  volumes."ubuntu22.10.qcow2" = {
    source = "https://cloud-images.ubuntu.com/kinetic/current/kinetic-server-cloudimg-amd64.img",
    format = `QCow2,
  },

  volumes."ubuntu" = {
    base_volume = volumes."ubuntu22.10.qcow2",
    size = 42949672960,
  },

  domains."ubuntu" = {
    memory = 4096,
    vcpu = 2,

    network_interfaces = [{
      network = networks."example",
      hostname = cloudinit.config.hostname,
      wait_for_lease = true,
      addresses = [ "10.17.3.2" ],
    }],

    disks = [
      { volume = volumes."ubuntu" }
    ],

    consoles = [{
      type = `Pty,
      target_type = `Serial,
      target_port = "0",
    }],

    cloudinit = {
      config = {
        hostname = "ubuntu",
        users = [
          {
            name = "ubuntu",
            sudo = "ALL=(ALL) NOPASSWD:ALL",
            ssh_authorized_keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP03cNnW4bB4rqxfp62V1SqskfI9Gja0+EApP9//tz+b vkleen@arbro" ],
          }
        ],
        growpart = {
          mode = "auto",
          devices = [ "/" ],
        },
      },
    },
  },

  config.output."ip".value = array.head (array.head domains."ubuntu".network_interfaces).addresses,
} | import "./libvirt.ncl"
