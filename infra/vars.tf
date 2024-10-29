variable "instance_type" {
  description = "This is the instance-type of the machine"
  default     = "t2.micro"
}

# variable "aws_public_key" {
#   description = "Hold the public key that will be pass by github action"
# }

variable "aws_private_key" {
  description = "Hold the private key that will be pass by github action"
}