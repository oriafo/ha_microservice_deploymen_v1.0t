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

# Define the SSH key pair names based on the environment
locals {
  ssh_key_name = var.environment_name == "dev" ? "bastonHost-key" : "bastonHost-key-prod"
}

# Data block to fetch the SSH key pair based on the environment
data "aws_key_pair" "my_key" {
  key_name = local.ssh_key_name
}


# data "aws_key_pair" "my_key" {
#   key_name = "bastonHost-key"           
# }

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



#the keys shold be chossen based on ref
# and the resources should have tags based on ref too.