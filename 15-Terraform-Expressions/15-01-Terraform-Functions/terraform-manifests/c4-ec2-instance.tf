# Create EC2 Instance - Amazon2 Linux
resource "aws_instance" "terraform_ec2_instance" {
  ami           = data.aws_ami.amzlinux.id
  instance_type = var.instance_type
  key_name      = "terraform-key"
  #user_data = file("apache-install.sh")  
  user_data              = templatefile("user_data.tmpl", { package_name = var.package_name })
  vpc_security_group_ids = [aws_security_group.terraform_vpc_ssh.id, aws_security_group.terraform_vpc_web.id]
  tags = {
    "Name" = "TF-Functions-Demo-1"
  }
}