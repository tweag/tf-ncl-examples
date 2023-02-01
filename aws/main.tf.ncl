let Tf = import "./schema.ncl" in
let Aws = import "./modules/aws.ncl" in
({
  aws.region = `eu-central-1,

  aws.state = {
    bucket = "tf-ncl-aws-example",
    key = "aws-demo.tfstate",
    region = aws.region,
  },

  aws.credentials.assume_role.role_arn = "arn:aws:iam::862822659803:role/tf-ncl-demo",

  aws.simple.networks.test = {
    cidr_block = {
      prefix = "10.1.0.0",
      length = 16,
    },
  },

  #
  #   resource."oci_core_instance"."test_instance" = {
  #     availability_domain = data.oci_identity_availability_domain.ad.name,
  #     compartment_id = "${var.compartment_ocid}",
  #     display_name = "TestInstance",
  #     shape = instance-shape,
  # 
  #     create_vnic_details = {
  #       subnet_id = resource.oci_core_subnet.test_subnet.id,
  #       display_name = "Primaryvnic",
  #       assign_public_ip = "true",
  #       hostname_label = "testinstance"
  #     },
  #
  #     source_details = {
  #       source_type = "image",
  #       source_id = instance-image-ocid."%{string.from oci.region}",
  #     },
  #
  #     shape_config = {
  #       ocpus = 1,
  #       memory_in_gbs = 6,
  #     },
  #
  #     metadata = {
  #       ssh_authorized_keys = "${var.ssh_public_key}"
  #     },
  #
  #     timeouts.create = "60m"
  #   },
  #
  #   resource."oci_core_instance_console_connection"."test_instance_console_connection" = {
  #     instance_id = resource.oci_core_instance.test_instance.id,
  #     public_key = "${var.ssh_public_key}"
  #   },
  #
  #   data."oci_core_vnic_attachments"."instance_vnics" = {
  #     compartment_id = "${var.compartment_ocid}",
  #     availability_domain = data.oci_identity_availability_domain.ad.name,
  #     instance_id = resource.oci_core_instance.test_instance.id,
  #   },
  #
  #   data."oci_core_vnic"."instance_vnic" = {
  #     vnic_id = m%"${data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0]["vnic_id"]}"%,
  #   },
  #
  #   output."connect_with_ssh".value = resource.oci_core_instance_console_connection.test_instance_console_connection.connection_string,
}
| Aws.Simple
| Aws.S3Backend
)| Tf.Config
