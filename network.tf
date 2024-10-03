# VPC
resource "aws_vpc" "lanchonete_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lanchonete_vpc"
  }
}

# Public Subnets
resource "aws_subnet" "lanchonete_public_subnet_1" {
  vpc_id            = aws_vpc.lanchonete_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "lanchonete_public_subnet_1"
  }
}

resource "aws_subnet" "lanchonete_public_subnet_2" {
  vpc_id            = aws_vpc.lanchonete_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "lanchonete_public_subnet_2"
  }
}

# Private Subnets
resource "aws_subnet" "lanchonete_private_subnet_1" {
  vpc_id            = aws_vpc.lanchonete_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "lanchonete_private_subnet_1"
  }
}

resource "aws_subnet" "lanchonete_private_subnet_2" {
  vpc_id            = aws_vpc.lanchonete_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "lanchonete_private_subnet_2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "lanchonete_app_igw" {
  vpc_id = aws_vpc.lanchonete_vpc.id

  tags = {
    Name = "lanchonete_app_igw"
  }
}

# Public route table
resource "aws_route_table" "lanchonete_app_public_rt" {
  vpc_id = aws_vpc.lanchonete_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lanchonete_app_igw.id
  }

  tags = {
    Name = "lanchonete_app_public_rt"
  }
}

# Public route table association - 1
resource "aws_route_table_association" "lanchonete_app_public_rt_association_1" {
  subnet_id      = aws_subnet.lanchonete_public_subnet_1.id
  route_table_id = aws_route_table.lanchonete_app_public_rt.id
}

# Public route table association - 2
resource "aws_route_table_association" "lanchonete_app_public_rt_association_2" {
  subnet_id      = aws_subnet.lanchonete_public_subnet_2.id
  route_table_id = aws_route_table.lanchonete_app_public_rt.id
}

# Private route table
resource "aws_route_table" "lanchonete_app_private_rt" {
  vpc_id = aws_vpc.lanchonete_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lanchonete_app_nat_gw.id
  }

  tags = {
    Name = "lanchonete_app_private_rt"
  }
}

# Private route table association - 1
resource "aws_route_table_association" "lanchonete_app_private_rt_association_1" {
  subnet_id      = aws_subnet.lanchonete_private_subnet_1.id
  route_table_id = aws_route_table.lanchonete_app_private_rt.id
}

# Private route table association - 2
resource "aws_route_table_association" "lanchonete_app_private_rt_association_2" {
  subnet_id      = aws_subnet.lanchonete_private_subnet_2.id
  route_table_id = aws_route_table.lanchonete_app_private_rt.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "lanchonete_app_nat_eip" {
  domain = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "lanchonete_app_nat_gw" {
  allocation_id = aws_eip.lanchonete_app_nat_eip.id
  subnet_id     = aws_subnet.lanchonete_public_subnet_1.id

  tags = {
    Name = "lanchonete_app_nat_gw"
  }
}