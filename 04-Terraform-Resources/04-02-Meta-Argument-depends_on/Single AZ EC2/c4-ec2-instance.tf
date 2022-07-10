# Resource 13 Create EC2 Public Instance
resource "aws_instance" "terraform_public_instance" {
  depends_on                  = [aws_internet_gateway.terraform_igw]
  associate_public_ip_address = true
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = "t2.micro"
  key_name                    = "terraform-key"
  subnet_id                   = aws_subnet.terraform_public_subnet.id
  vpc_security_group_ids      = ["${aws_security_group.terraform_allow_ssh.id}"]

  tags = {
    Name = "Terraform-Public-Instance"
  }
}

# Resource 14 Create EC2 Private Instance
resource "aws_instance" "terraform_private_instance" {
  depends_on             = [aws_nat_gateway.terraform_nat_gateway]
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = "terraform-key"
  subnet_id              = aws_subnet.terraform_private_subnet.id
  vpc_security_group_ids = ["${aws_security_group.terraform_allow_ssh.id}"]
  user_data              = file("app1-install.sh")

  tags = {
    Name = "Terraform-Private-Instance"
  }
}