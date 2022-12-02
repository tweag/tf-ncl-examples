let LibvirtTf = import "./libvirt/schema.ncl" in
{
  config | LibvirtTf.Schema = {
      provider.libvirt = [
        { uri = "qemu://session" }
      ],
    },
    renderable_config = LibvirtTf.mkConfig config,
}
& import "./libvirt/network.ncl"
& import "./libvirt/volume.ncl"
& import "./libvirt/domain.ncl"
