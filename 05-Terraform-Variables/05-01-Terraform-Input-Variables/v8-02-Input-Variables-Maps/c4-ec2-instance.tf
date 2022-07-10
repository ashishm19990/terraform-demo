# Create EC2 Instance
resource "aws_instance" "terraform_ec2_instance" {
  ami = var.ec2_ami_id
  #instance_type          = var.ec2_instance_type[0]
  instance_type          = var.ec2_instance_type_map["small-apps"]
  key_name               = "terraform-key"
  count                  = var.ec2_instance_count
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to Vardhman Garments ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
    EOF
  vpc_security_group_ids = [aws_security_group.terraform_vpc_ssh.id, aws_security_group.terraform_vpc_web.id]
  tags                   = var.ec2_instance_tags
}
