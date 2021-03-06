# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type        = string
}