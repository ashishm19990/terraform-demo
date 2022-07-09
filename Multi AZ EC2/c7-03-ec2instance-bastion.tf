resource "aws_instance" "terraform_public_instance" {
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  vpc_security_group_ids = [aws_security_group.terraform_allow_web.id, aws_security_group.terraform_allow_ssh.id]
  subnet_id              = aws_subnet.terraform_public_subnet[0].id
  user_data              = file("app1-install.sh")
  tags = {
    Name        = "${local.name}-Terraform-Public-Instance"
    Environment = "${var.environment}"
  }
}
