let Aws = import "./types.ncl" in
let Utils = import "../utils.ncl" in
{
  aws.simple.ec2.instances | {_: {
    ami | Str,
    type | Str,
    public_key_name | Str,
    network,
  }}
  | default = {},

  config = aws.simple.ec2.instances |> record.fields |> array.map (fun name => let
    cfg = aws.simple.ec2.instances."%{name}"
  in {
    resource.aws_security_group."%{name}_forwarder" = {
      vpc_id = cfg.network.vpc.id,
      ingress = [{
        from_port = 22,
        protocol = "tcp",
        to_port = 22,
        cidr_blocks = ["0.0.0.0/0"],

        description = "${null}",
        ipv6_cidr_blocks = [],
        prefix_list_ids = [],
        security_groups = [],
        self = false,
      }],
    },

    resource.aws_instance."%{name}" = {
      ami = cfg.ami,
      instance_type = cfg.type,
      subnet_id = cfg.network.subnet.id,
      vpc_security_group_ids = [  ],
      key_name = cfg.public_key_name,
    },
  }) |> Utils.merge_array,
}
