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


resource "aws_instance" "provisioner_machine" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.my_key.key_name
  vpc_security_group_ids = [ data.aws_security_group.default.id ]
  tags = {
    Name = "provisioner_machine-${ github.head_ref }"
  }
  provisioner "file" {
    source      = "web.sh"                                      # Local file path
    destination = "/home/ubuntu/web.sh"                         # Destination on the instance
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = var.aws_private_key    
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/web.sh",                            # Make the file executable
      "/home/ubuntu/web.sh",                                     # Execute the file
    ]

    # Connect to the instance
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = var.aws_private_key     
    }
  }
}

