resource "aws_instance" "terraform_private_instance" {
  depends_on             = [aws_nat_gateway.terraform_nat_gateway]
  count                  = length(var.vpc_private_subnets)
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  vpc_security_group_ids = [aws_security_group.terraform_allow_web.id, aws_security_group.terraform_allow_ssh.id]
  subnet_id              = aws_subnet.terraform_private_subnet.*.id[count.index]
  user_data              = file("app1-install.sh")

  tags = {
    Name        = "${local.name}-Terraform-Private-Instance-${count.index}"
    Environment = "${var.environment}"
  }
}
