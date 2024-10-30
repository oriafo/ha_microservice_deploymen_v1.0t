# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonicall
# }

data "aws_key_pair" "my_key" {
  key_name = "bastonHost-key"           # Replace with the name of your key pair
}

data "aws_vpc" "default" {
  default = true
}

data "http" "public_ip" {
  url = "https://api.ipify.org"
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "group-name"
    values = ["default"]  # The name of the default security group is usually "default"
  }
}
