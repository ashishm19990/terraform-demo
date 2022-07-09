resource "aws_instance" "terraform-ec2-vm" {
  ami               = "ami-0cff7528ff583bf9a"
  instance_type     = "t2.micro"
  key_name          = "terraform-key"
  availability_zone = "us-east-1a"
  tags = {
    "Name"        = "Terraform-EC2-Instance"
    "Environment" = "Dev"
    "tag1"        = "update-test-1"
  }
}