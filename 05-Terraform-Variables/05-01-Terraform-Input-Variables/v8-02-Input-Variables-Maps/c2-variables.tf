# Input Variables
variable "aws_region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0cff7528ff583bf9a" # Amazon2 Linux AMI ID
}

variable "ec2_instance_count" {
  description = "EC2 Instance Count"
  type        = number
  default     = 2
}

/*
variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type = list(string)
  default = ["t3.micro", "t3.small", "t3.large"]
}
*/


variable "ec2_instance_tags" {
  description = "EC2 Instance Tags"
  type        = map(string)
  default = {
    "Name" = "terraform-ec2-instance-web"
    "Tier" = "Web"
  }
}

variable "ec2_instance_type_map" {
  description = "EC2 Instance Type"
  type        = map(string)
  default = {
    "small-apps"  = "t2.micro"
    "medium-apps" = "t2.small"
    "big-apps"    = "t2.medium"
  }
}