
# Create a VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Custom VPC"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "Custom IGW"
  }
}

# Create public subnets in three availability zones
resource "aws_subnet" "public_subnet_az1" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.cidr_blocks_public_subnet[0]
  availability_zone = "us-west-2a"
  tags = {
    Name = "Public Subnet AZ1"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.cidr_blocks_public_subnet[1]
  availability_zone = "us-west-2b"
  tags = {
    Name = "Public Subnet AZ2"
  }
}


# Create private subnets in three availability zones
resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.cidr_blocks_private_subnet[0]
  availability_zone = "us-west-2a"
  tags = {
    Name = "Private Subnet AZ1"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.cidr_blocks_private_subnet[1]
  availability_zone = "us-west-2b"
  tags = {
    Name = "Private Subnet AZ2"
  }
}



# Create a route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "Public Route Table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public_subnet_association_az1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_az2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a route table for private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "Private Route Table"
  }
}

# Associate the private subnets with the private route table
resource "aws_route_table_association" "private_subnet_association_az1" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_az2" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}


