# AWS EC2 Instance Module
module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  name  = "terraform-modules-demo"
  count = 2

  ami                    = data.aws_ami.amzlinux.id
  instance_type          = "t2.micro"
  key_name               = "terraform-key"
  monitoring             = true
  vpc_security_group_ids = ["sg-0983f86d2902e901b"]   # Get Default VPC Security Group ID and replace
  subnet_id              = "subnet-0d11bc38c3953d9f1" # Get one public subnet id from default vpc and replace
  user_data              = file("apache-install.sh")

  tags = {
    Name        = "Terraform-Modules-Demo"
    Terraform   = "true"
    Environment = "dev"
  }
}

