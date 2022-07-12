# Create EC2 Instance - Amazon Linux
resource "aws_instance" "terraform_ec2_instance" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  key_name               = "terraform-key"
  count                  = terraform.workspace == "default" ? 2 : 1
  user_data              = file("apache-install.sh")
  vpc_security_group_ids = [aws_security_group.terraform_vpc_ssh.id, aws_security_group.terraform_vpc_web.id]
  tags = {
    "Name" = "terraform-ec2-instance-${terraform.workspace}-${count.index}"
  }
}