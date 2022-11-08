let LibvirtTf = import "./libvirt/schema.ncl" in
{
  config | LibvirtTf.Configuration
    | _push_default = {
      provider.libvirt = [
        { uri = "qemu://session" }
      ],
  },

  renderable_config | default = LibvirtTf.mkConfig config,
}
& import "./libvirt/network.ncl"
