/*=========== The VPC ===================*/
resource "aws_vpc" "terraform_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name        = "${local.name}-${var.vpc_name}"
    Environment = "${var.environment}"
  }
}

/*=========================== Public subnet===============================*/
resource "aws_subnet" "terraform_public_subnet" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  count                   = length(var.vpc_public_subnets)
  cidr_block              = var.vpc_public_subnets[count.index]
  availability_zone       = var.vpc_availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name        = "${local.name}-${var.vpc_availability_zones[count.index]}-terraform-public-subnet"
    Environment = "${var.environment}"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name        = "${local.name}-terraform-igw"
    Environment = "${var.environment}"
  }
}

/* ============= Route Table For Public Subnet ============= */
resource "aws_route_table" "terraform_public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name        = "${local.name}-terraform-public-route-table"
    Environment = "${var.environment}"
  }
}

/* ==========  The routing table to associate with public subnet =============== */
resource "aws_route_table_association" "terraform_public_route_table_association" {
  count          = length(var.vpc_public_subnets)
  subnet_id      = aws_subnet.terraform_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.terraform_public_route_table.id
}

/* ======================= Route For Internet Gateway ==================== */
resource "aws_route" "terraform_public_route" {
  route_table_id         = aws_route_table.terraform_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.terraform_igw.id
  depends_on             = [aws_route_table.terraform_public_route_table]
}

/* ======================== Private Subnet ============================== */
resource "aws_subnet" "terraform_private_subnet" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  count                   = length(var.vpc_private_subnets)
  cidr_block              = var.vpc_private_subnets[count.index]
  availability_zone       = var.vpc_availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name        = "${local.name}-${var.vpc_availability_zones[count.index]}-terraform-private-subnet"
    Environment = "${var.environment}"
  }
}

/* =================== Create NAT Gateway ========================= */
resource "aws_nat_gateway" "terraform_nat_gateway" {
  allocation_id = aws_eip.terraform_eip.id
  subnet_id     = aws_subnet.terraform_public_subnet[0].id
  depends_on    = [aws_internet_gateway.terraform_igw]
  tags = {
    Name        = "${local.name}-terraform-nat-gateway"
    Environment = "${var.environment}"
  }
}

/* ====== Create Route Table For Private Subnet =========== */
resource "aws_route_table" "terraform_private_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name        = "${local.name}-terraform-private-route-table"
    Environment = "${var.environment}"
  }
}

/* ============= Route Table Association For Private Subnet ======================= */
resource "aws_route_table_association" "terraform_private_route_table_association" {
  count          = length(var.vpc_private_subnets)
  subnet_id      = aws_subnet.terraform_private_subnet.*.id[count.index]
  route_table_id = aws_route_table.terraform_private_route_table.id
}

/* ======================= Route For NAT  Gateway ==================== */
resource "aws_route" "terraform_private_route" {
  depends_on             = [aws_nat_gateway.terraform_nat_gateway]
  route_table_id         = aws_route_table.terraform_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.terraform_nat_gateway.id
}