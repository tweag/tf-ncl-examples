let Tf = import "./schema.ncl" in
let Aws = import "./modules/aws.ncl" in
let ami-id = match {
  `eu-central-1 => "ami-0f1cf34dcb4057a5f",
} in
let private-key-path = "./ec2_key" in
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

  aws.simple.ec2.instances = {
    test = {
      ami = ami-id aws.region,
      type = "t2.micro",
      network = aws.simple.networks.test,
      public_key_name = "${resource.aws_key_pair.ssh_key.key_name}",
    },
  },

  config = {
    data.external.ssh_key = {
      program = [ "./ssh-pubkey.sh", private-key-path ],
    },

    resource.aws_key_pair.ssh_key = {
      public_key = "${data.external.ssh_key.result.public_key}",
    },

    output."instance_ip".value = aws.simple.ec2.instances.test.public_ip,
  },
}
| Aws.Simple
| Aws.S3Backend
)| Tf.Config
