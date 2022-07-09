terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.21"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "terraform_public_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "terraform-public-subnet"
  }
}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "terraform_public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-public-route-table"
  }
}

resource "aws_route_table_association" "terraform_public_route_table_association" {
  subnet_id      = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_route_table.terraform_public_route_table.id
}

resource "aws_route" "terraform_public_route" {
  route_table_id         = aws_route_table.terraform_public_route_table.id
  gateway_id             = aws_internet_gateway.terraform_igw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.terraform_public_route_table]
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

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

resource "aws_instance" "terraform_public_instance" {
  depends_on                  = [aws_internet_gateway.terraform_igw]
  associate_public_ip_address = true
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = "t2.micro"
  key_name                    = "officeyahoo"
  subnet_id                   = aws_subnet.terraform_public_subnet.id
  vpc_security_group_ids      = ["${aws_security_group.terraform_allow_ssh.id}"]
  user_data                   = file("app1-install.sh")
  tags = {
    Name = "Terraform-Public-Instance"
  }
}

resource "aws_subnet" "terraform_private_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-private-subnet"
  }
}

resource "aws_eip" "terraform_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.terraform_igw]
}

resource "aws_nat_gateway" "terraform_nat_gateway" {
  allocation_id = aws_eip.terraform_eip.id
  subnet_id     = aws_subnet.terraform_private_subnet.id

  tags = {
    Name = "terraform-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraform_igw]
}


resource "aws_route_table" "terraform_private_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-private-route-table"
  }
}

resource "aws_route_table_association" "terraform_private_route_table_association" {
  subnet_id      = aws_subnet.terraform_private_subnet.id
  route_table_id = aws_route_table.terraform_private_route_table.id
}

resource "aws_route" "terraform_private_route" {
  depends_on             = [aws_nat_gateway.terraform_nat_gateway]
  route_table_id         = aws_route_table.terraform_private_route_table.id
  gateway_id             = aws_nat_gateway.terraform_nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_instance" "terraform_private_instance" {
  depends_on             = [aws_nat_gateway.terraform_nat_gateway]
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = "officeyahoo"
  subnet_id              = aws_subnet.terraform_private_subnet.id
  vpc_security_group_ids = ["${aws_security_group.terraform_allow_ssh.id}"]
  tags = {
    Name = "Terraform-Private-Instance"
  }
}

