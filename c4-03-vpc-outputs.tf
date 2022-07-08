# VPC Output Values

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.terraform_vpc.id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.terraform_vpc.cidr_block
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.terraform_private_subnet[*].id
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.terraform_public_subnet[*].id
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_nat_gateway.terraform_nat_gateway.public_ip
}
