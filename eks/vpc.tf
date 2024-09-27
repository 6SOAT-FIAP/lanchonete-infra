## VPC
#resource "aws_vpc" "lanchonete-api_vpc" {
#  cidr_block       = var.vpc_cidr
#  instance_tenancy = "default"
#}
#
#resource "aws_internet_gateway" "lanchonete-api_gw" {
#  vpc_id = aws_vpc.lanchonete-api_vpc.id
#}
#
#data "aws_availability_zones" "available" {
#}
#
#resource "random_shuffle" "az_list" {
#  input        = data.aws_availability_zones.available.names
#  result_count = 2
#}
#
#resource "aws_subnet" "public_lanchonete-api_subnet" {
#  count                   = var.public_sn_count
#  vpc_id                  = aws_vpc.lanchonete-api_vpc.id
#  cidr_block              = var.public_cidrs[count.index]
#  availability_zone       = random_shuffle.az_list.result[count.index]
#  map_public_ip_on_launch = true
#}
#
#resource "aws_default_route_table" "internal_lanchonete-api_default" {
#  default_route_table_id = aws_vpc.lanchonete-api_vpc.default_route_table_id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.lanchonete-api_gw.id
#  }
#}
#
#resource "aws_route_table_association" "default" {
#  count          = var.public_sn_count
#  subnet_id      = aws_subnet.public_lanchonete-api_subnet[count.index].id
#  route_table_id = aws_default_route_table.internal_lanchonete-api_default.id
#}

resource "aws_vpc" "lanchonete-api_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lanchonete-api_vpc"
  }

  lifecycle {
    prevent_destroy       = false
  }

}

# Public Subnet - 1
resource "aws_subnet" "lanchonete-api_public_subnet_1" {
  vpc_id            = aws_vpc.lanchonete-api_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zones[0]

  # map_public_ip_on_launch = true # Prevent errors due to destroy process

  lifecycle {
    prevent_destroy       = false
  }

  tags = {
    Name = "lanchonete-api_public_subnet_1"
  }

}

# Public Subnet - 2
resource "aws_subnet" "lanchonete-api_public_subnet_2" {
  vpc_id            = aws_vpc.lanchonete-api_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zones[1]

  lifecycle {
    prevent_destroy       = false
  }

  tags = {
    Name = "lanchonete-api_public_subnet_2"
  }
}

# Private Subnet - 1
resource "aws_subnet" "lanchonete-api_private_subnet_1" {
  vpc_id            = aws_vpc.lanchonete-api_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.availability_zones[0]

  lifecycle {
    prevent_destroy       = false
  }

  tags = {
    Name = "lanchonete-api_private_subnet_1"
  }
}

# Private Subnet - 2
resource "aws_subnet" "lanchonete-api_private_subnet_2" {
  vpc_id            = aws_vpc.lanchonete-api_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "lanchonete-api_private_subnet_2"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Internet Gateway
resource "aws_internet_gateway" "lanchonete-api_igw" {
  vpc_id = aws_vpc.lanchonete-api_vpc.id

  lifecycle {
    prevent_destroy       = false
  }

  tags = {
    Name = "lanchonete-api_igw"
  }
}

# Public route table
resource "aws_route_table" "lanchonete-api_public_rt" {
  vpc_id = aws_vpc.lanchonete-api_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lanchonete-api_igw.id
  }

  tags = {
    Name = "lanchonete-api_public_rt"
  }
}

# Public route table association - 1
resource "aws_route_table_association" "lanchonete-api_public_rt_association_1" {
  subnet_id      = aws_subnet.lanchonete-api_public_subnet_1.id
  route_table_id = aws_route_table.lanchonete-api_public_rt.id
}

# Public route table association - 2
resource "aws_route_table_association" "lanchonete-api_public_rt_association_2" {
  subnet_id      = aws_subnet.lanchonete-api_public_subnet_2.id
  route_table_id = aws_route_table.lanchonete-api_public_rt.id
}

# Private route table
resource "aws_route_table" "lanchonete-api_private_rt" {
  vpc_id = aws_vpc.lanchonete-api_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lanchonete-api_nat_gw.id
  }

  tags = {
    Name = "lanchonete-api_private_rt"
  }
}

# Private route table association - 1
resource "aws_route_table_association" "lanchonete-api_private_rt_association_1" {
  subnet_id      = aws_subnet.lanchonete-api_private_subnet_1.id
  route_table_id = aws_route_table.lanchonete-api_private_rt.id
}

# Private route table association - 2
resource "aws_route_table_association" "lanchonete-api_private_rt_association_2" {
  subnet_id      = aws_subnet.lanchonete-api_private_subnet_2.id
  route_table_id = aws_route_table.lanchonete-api_private_rt.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "lanchonete-api_nat_eip" {
  domain = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "lanchonete-api_nat_gw" {
  allocation_id = aws_eip.lanchonete-api_nat_eip.id
  subnet_id     = aws_subnet.lanchonete-api_public_subnet_1.id

  tags = {
    Name = "lanchonete-api_nat_gw"
  }
}