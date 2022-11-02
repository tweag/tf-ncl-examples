let Tf = import "./schema.ncl" in

let fold_fn : forall r. {;r} -> {;r} -> {;r}
            = fun r acc => acc & r
    in
let for_count : forall r. Num -> (Num -> {;r}) -> {;r}
              = fun c f =>
      array.fold fold_fn {} (array.generate f c)
    in
let num_masternodes = 1 in
let num_workernodes = 2 in
let kube = "1.18.0" in
let pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP03cNnW4bB4rqxfp62V1SqskfI9Gja0+EApP9//tz+b vkleen@arbro" in

let volume = fun resource tag c => {
    name = "ubuntu-volume-%{tag}-%{string.from c}",
    base_volume_id  = resource.libvirt_volume.ubuntu_cloud.id,
    pool = resource.libvirt_pool.local.name,
    size = 42949672960,
  } in

let cloudinit = fun resource tag c => {
    pool = resource.libvirt_pool.local.name,
    user_data = (import "./cloud_init.ncl").cloud_init {
      hostname = "k8s-%{tag}-%{string.from c}",
      kube_version = kube,
      ssh_pubkey = pubkey,
    },
  } in
let master_cloudinit_disk = fun resource c => cloudinit resource "master" c & {
    name = "cloudinit_master_%{string.from c}.iso",
  } in
let worker_cloudinit_disk = fun resource c => cloudinit resource "worker" c & {
    name = "cloudinit_worker_%{string.from c}.iso",
  } in

let cfg = {
  provider.libvirt = [{
    uri = "qemu:///system",
  }],
  resource = {
    libvirt_pool.local = {
      name = "ubuntu",
      type = "dir",
      path = "/var/lib/libvirt/test",
    },

    libvirt_volume = {
      ubuntu_cloud = {
        name = "ubuntu22.10.qcow2",
        pool = resource.libvirt_pool.local.name,
        source = "https://cloud-images.ubuntu.com/kinetic/current/kinetic-server-cloudimg-amd64.img",
        format = "qcow2",
      },
    } &
    (for_count num_masternodes (fun c => {
      "ubuntu-master-%{string.from c}" = volume resource "master" c,
    })) &
    (for_count num_workernodes(fun c => {
      "ubuntu-worker-%{string.from c}" = volume resource "worker" c,
    })),

    libvirt_cloudinit_disk =
        for_count num_masternodes (fun c => {
          "master-%{string.from c}" = master_cloudinit_disk resource c
        })
      & for_count num_workernodes (fun c => {
          "worker-%{string.from c}" = worker_cloudinit_disk resource c
      }),

    libvirt_network.kube_node_network = {
      name = "kube_node",
      mode = "nat",
      domain = "k8s.local",
      autostart = true,
      addresses = [ "172.16.1.0/24" ],
      dns = [{ enabled = true, }],
    },

    libvirt_domain =
      for_count num_masternodes (fun c => {
        "k8s-master-%{string.from c}" = {
          name = "k8s-master-%{string.from c}",
          memory = 4096,
          vcpu = 2,
          
          cloudinit = resource.libvirt_cloudinit_disk."master-%{string.from c}".id,

          network_interface = [{
            network_id = resource.libvirt_network.kube_node_network.id,
            hostname = "k8s-master-%{string.from c}",
            addresses = ["172.16.1.%{string.from (100 + c)}"],
            wait_for_lease = true,
          }],

          disk = [{
            volume_id = resource.libvirt_volume."ubuntu-master-%{string.from c}".id,
            scsi = false,
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
      }) &
      for_count num_workernodes (fun c => {
        "k8s-worker-%{string.from c}" = {
          name = "k8s-worker-%{string.from c}",
          memory = 2048,
          vcpu = 2,

          cloudinit = resource.libvirt_cloudinit_disk."worker-%{string.from c}".id,

          network_interface = [{
            network_id = resource.libvirt_network.kube_node_network.id,
            hostname = "k8s-worker-%{string.from c}",
            addresses = ["172.16.1.%{string.from (200+c)}"],
            wait_for_lease = true,
          }],

          disk = [{
            volume_id = resource.libvirt_volume."ubuntu-worker-%{string.from c}".id,
            scsi = false,
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
      }),
  },

  output =
    for_count num_masternodes (fun c => {
      "ip-master-%{string.from c}".value = array.elem_at 0 (array.elem_at 0 resource.libvirt_domain."k8s-master-%{string.from c}".network_interface).addresses,
      "master-%{string.from c}-id".value = resource.libvirt_domain."k8s-master-%{string.from c}".id,
    }) &
    for_count num_workernodes (fun c => {
      "ip-worker-%{string.from c}".value = array.elem_at 0 (array.elem_at 0 resource.libvirt_domain."k8s-worker-%{string.from c}".network_interface).addresses,
      "worker-%{string.from c}-id".value = resource.libvirt_domain."k8s-worker-%{string.from c}".id,
    }),
} | Tf.Configuration
in Tf.mkConfig cfg
