# AWS EC2 Security Group Terraform Outputs

# Public Bastion Host Security Group Outputs
## public_bastion_sg_group_id
output "terraform_public_bastion_sg_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.terraform_allow_ssh.id
}

## public_bastion_sg_group_vpc_id
output "terraform_public_bastion_sg_group_vpc_id" {
  description = "The VPC ID"
  value       = aws_security_group.terraform_allow_ssh.vpc_id
}

## public_bastion_sg_group_name
output "terraform_public_bastion_sg_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.terraform_allow_ssh.name
}

# Private EC2 Instances Security Group Outputs
## private_sg_group_id
output "terraform_private_sg_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.terraform_allow_web.id
}

## private_sg_group_vpc_id
output "terraform_private_sg_group_vpc_id" {
  description = "The VPC ID"
  value       = aws_security_group.terraform_allow_web.vpc_id
}

## private_sg_group_name
output "terraform_private_sg_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.terraform_allow_web.name
}