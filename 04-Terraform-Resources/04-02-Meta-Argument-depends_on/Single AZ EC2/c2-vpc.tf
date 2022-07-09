# Resources Block
# Resource-1: Create VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

# Resource-2: Create Public Subnets
resource "aws_subnet" "terraform_public_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "terraform-public-subnet"
  }
}

# Resource-3: Internet Gateway
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

# Resource-4: Create Public Route Table
resource "aws_route_table" "terraform_public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-public-route-table"
  }
}

# Resource-5: Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "terraform_public_route_table_association" {
  subnet_id      = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_route_table.terraform_public_route_table.id
}

# Resource-6: Create Route in Route Table for Internet Access
resource "aws_route" "terraform_public_route" {
  route_table_id         = aws_route_table.terraform_public_route_table.id
  gateway_id             = aws_internet_gateway.terraform_igw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.terraform_public_route_table]
}

# Resource-7: Create Security Group
resource "aws_security_group" "terraform_allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "Allow All IP and Ports Outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform_allow_ssh"
  }
}

# Resource-8: Create Private Subnets
resource "aws_subnet" "terraform_private_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-private-subnet"
  }
}

# Resource-9: NAT Gateway Should In Public Subnet
resource "aws_nat_gateway" "terraform_nat_gateway" {
  allocation_id = aws_eip.terraform_eip.id
  subnet_id     = aws_subnet.terraform_public_subnet.id

  tags = {
    Name = "terraform-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraform_igw]
}

# Resource-10: Create Private Route Table
resource "aws_route_table" "terraform_private_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-private-route-table"
  }
}

# Resource-11: Associate the Route Table with the Private Subnet
resource "aws_route_table_association" "terraform_private_route_table_association" {
  subnet_id      = aws_subnet.terraform_private_subnet.id
  route_table_id = aws_route_table.terraform_private_route_table.id
}

# Resource-12: Create Route in Route Table for NAT Gateway
resource "aws_route" "terraform_private_route" {
  depends_on             = [aws_nat_gateway.terraform_nat_gateway]
  route_table_id         = aws_route_table.terraform_private_route_table.id
  gateway_id             = aws_nat_gateway.terraform_nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}