# Create EC2 Instance
resource "aws_instance" "terraform_ec2_instance" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  count                  = 1
  key_name               = "terraform-key"
  user_data              = file("apache-install.sh")
  vpc_security_group_ids = [aws_security_group.terraform_vpc_ssh.id, aws_security_group.terraform_vpc_web.id]
  tags = {
    "Name" = "Terraform-Cloud-${count.index}"
  }
}