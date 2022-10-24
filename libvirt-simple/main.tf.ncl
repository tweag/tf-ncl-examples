let Tf = import "./schema.ncl" in
let cfg = {
  provider.libvirt = [
    { uri = "qemu:///session" },
  ],

  resource."libvirt_network"."example" = {
    name = "example",
    mode = "nat",
    domain = "example.test",
    addresses = [ "10.17.3.0/24" ],
    dhcp = [{
      enabled = false,
    }],
    dns = [{
      enabled = true,
      local_only = false,
    }],
  },

  resource."libvirt_volume"."centos7-qcow2" = {
    name = "centos7.qcow2",
    pool = "default",
    source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2",
    format = "qcow2",
  },

  resource."libvirt_domain"."centos7" = {
    name = "centos7",
    memory = 2048,
    vcpu = 2,
    network_interface = [{
      network_id = resource.libvirt_network.example.id,
      wait_for_lease = true,
      addresses = [ "10.17.3.2" ],
    }],
    disk = [{
      volume_id = resource.libvirt_volume.centos7-qcow2.id,
      scsi = true,
      #TODO(vkleen): Someone somewhere is lying about optional fields
      file = "",
      block_device = "",
      url = "",
      wwn = "",
    }],
    console = [{
      type = "pty",
      target_type = "serial",
      target_port = "0",
    }],
  },

#TODO(vkleen): outputs?
} | Tf.Configuration in
Tf.mkConfig cfg
