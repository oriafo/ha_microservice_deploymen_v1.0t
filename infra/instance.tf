terraform {
  #   backend "s3" {
  #   bucket         = "oriafostatebbucket"
  #   key            = "infraa.tfstate"
  #   region         = "us-east-1"         
  #   dynamodb_table = "ab-provisioner-lock"    
  #   encrypt        = true                   
  # }
    
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


# resource "aws_key_pair" "pub_key" {
#   key_name = "key"  # Replace with the name of your key pair
#   public_key = var.aws_public_key
# }

# Create a security group for instances
# resource "aws_security_group" "instances" {
#   name        = "instances-sg"
#   description = "Allow HTTP inbound traffic and all outbound traffic"
#   vpc_id      = data.aws_vpc.default.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["${data.http.public_ip.body}/32"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
#   }
# }

resource "aws_instance" "provisioner_machine" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.my_key.key_name
  #key_name      = var.aws_public_key
  security_groups = [ aws_security_group.default ]
  tags = {
    Name = "provisioner_machine"
  }
  provisioner "file" {
    source      = "web.sh"                # Local file path
    destination = "/home/ubuntu/web.sh" # Destination on the instance
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = var.aws_private_key    # Path to your SSH key
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/web.sh", # Make the file executable
      "/home/ubuntu/web.sh",         # Execute the file
    ]

    # Connect to the instance
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = var.aws_private_key     # Path to your SSH key
    }
  }
}

