# Define Output Values

# Attribute Reference
output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.terraform_ec2_instance.*.public_ip
}


# Attribute Reference - Create Public DNS URL
output "ec2_publicdns" {
  description = "Public DNS URL of an EC2 Instance"
  value       = aws_instance.terraform_ec2_instance.*.public_dns
}

# Concat Security Group IDs in Output
output "security_group_ids" {
  description = "This will return the IDs of the security groups attached to your web instance as a list. You can use these lists as inputs in submodules"
  value       = concat([aws_security_group.terraform_vpc_ssh.id, aws_security_group.terraform_vpc_web.id])
}
/* Note: This will return the IDs of the security groups attached to your web 
instance as a list. You can use these lists as inputs in submodules.*/

