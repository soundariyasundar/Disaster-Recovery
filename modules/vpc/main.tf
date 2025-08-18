terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "network" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = var.vpc_name }
}

resource "aws_internet_gateway" "network" {
  vpc_id = aws_vpc.network.id
  tags   = { Name = "${var.vpc_name}-igw" }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.network.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
    Tier = "Web"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.network.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
    Tier = "App"
  }
}

resource "aws_subnet" "db" {
  count             = length(var.db_subnet_cidrs)
  vpc_id            = aws_vpc.network.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "${var.vpc_name}-db-${count.index + 1}"
    Tier = "DB"
  }
}

resource "aws_eip" "nat" {
  count  = length(var.nat_gw_subnet_indexes)
  domain = "vpc"
  tags   = { Name = "${var.vpc_name}-nat-eip-${count.index+1}" }
}

resource "aws_nat_gateway" "network" {
  count         = length(var.nat_gw_subnet_indexes)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[var.nat_gw_subnet_indexes[count.index]].id
  tags          = { Name = "${var.vpc_name}-natgw-${count.index+1}" }
  depends_on    = [aws_internet_gateway.network]
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.network.id
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}


resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.network.id
}


resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.network.id
  tags = { Name = "${var.vpc_name}-private-rt-${count.index+1}" }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route" "private_nat_gateway" {
  count                  = length(var.nat_gw_subnet_indexes)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.network[count.index].id
}
