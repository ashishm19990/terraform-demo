# Define Output Values
# Attribute Reference: EC2 Instance Public IP
output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.terraform_ec2_instance.*.public_ip
}

# Argument Reference: EC2 Instance Private IP
output "ec2_instance_privateip" {
  description = "EC2 Instance Private IP"
  value       = aws_instance.terraform_ec2_instance.*.private_ip
}
# Argument Reference: Security Groups associated to EC2 Instance
output "ec2_security_groups" {
  description = "List Security Groups associated with EC2 Instance"
  value       = aws_instance.terraform_ec2_instance.*.security_groups
}

# Attribute Reference - Create Public DNS URL
output "ec2_publicdns" {
  description = "Public DNS URL of an EC2 Instance"
  value       = aws_instance.terraform_ec2_instance.*.public_dns
}