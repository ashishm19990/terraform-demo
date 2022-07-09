# AWS EC2 Instance Terraform Outputs
# Public EC2 Instances - Bastion Host

## ec2_bastion_public_instance_ids
output "terraform_ec2_bastion_public_instance_ids" {
  description = "List of IDs of instances"
  value       = aws_instance.terraform_public_instance.id
}

## ec2_bastion_public_ip
output "terraform_ec2_bastion_public_instance_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = aws_instance.terraform_public_instance.public_ip
}

# Private EC2 Instances
## ec2_private_instance_ids
output "terraform_ec2_private_instance_ids" {
  description = "List of IDs of instances"
  value       = aws_instance.terraform_private_instance.*.id
}

## ec2_private_ip
output "terraform_ec2_private_instance_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.terraform_private_instance.*.private_ip
}