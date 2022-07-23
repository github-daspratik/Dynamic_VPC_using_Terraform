# Data Block
data "aws_availability_zones" "az" {
  state = "available"
}

# Create VPC in US-WEST-2
resource "aws_vpc" "myvpc" {
  cidr_block                     = "${var.vpc_network}/${var.vpc_netmask}"
  enable_dns_hostnames           = "true"
  enable_dns_support             = "true"
  enable_classiclink             = "false"
  enable_classiclink_dns_support = "false"
  instance_tenancy               = "default"
  tags = {
    "Name"        = var.vpc_name
    "Environment" = var.environment
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  count  = var.public_subnet_count > 0 ? 1 : 0
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name"        = "${var.vpc_name}-igw"
    "Environment" = var.environment
  }
}

# Create Public Subnets in the VPC
resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = cidrsubnet("${var.vpc_network}/${var.vpc_netmask}", ceil(log((var.public_subnet_count + var.private_subnet_count), 2)), count.index)
  availability_zone       = element(data.aws_availability_zones.az.names, count.index)
  map_public_ip_on_launch = "true"
  tags = {
    Name          = "PublicSubnet-${count.index + 1}"
    "Environment" = var.environment
  }
}

# Create Private Subnets in the VPC
resource "aws_subnet" "private_subnet" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = cidrsubnet("${var.vpc_network}/${var.vpc_netmask}", ceil(log((var.public_subnet_count + var.private_subnet_count), 2)), (count.index + var.public_subnet_count))
  availability_zone       = element(data.aws_availability_zones.az.names, count.index)
  map_public_ip_on_launch = "false"
  tags = {
    Name          = "PrivateSubnet-${count.index + 1}"
    "Environment" = var.environment
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  count  = var.public_subnet_count > 0 ? 1 : 0
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[count.index].id
  }
  tags = {
    Name        = "${var.vpc_name}-public-RT"
    Environment = var.environment
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  count  = var.private_subnet_count > 0 ? 1 : 0
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name        = "${var.vpc_name}-private-RT"
    Environment = var.environment
  }
}

# Associate the public subnets to public route table
resource "aws_route_table_association" "public_rt_association" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.public_rt.*.id, count.index)
}

# Associate the private subnets to private route table
resource "aws_route_table_association" "private_rt_association" {
  count          = var.private_subnet_count
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}

/*
resource "aws_vpc" "myvpc_us-west-1" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  instance_tenancy     = "default"
  #<PROVIDER NAME>.<ALIAS>
  provider = aws.california
  tags = {
    "Name"        = "myVPC_us-west-1"
    "Environment" = "Prod"
  }
}
*/