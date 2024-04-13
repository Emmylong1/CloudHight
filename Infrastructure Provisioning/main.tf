# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Cloudhight-VPC1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Cloudhight-IGW1"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_blocks_public_subnet[0]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[0]  # Specify the correct availability zone here
  tags = {
    Name = "Cloudhight-public-Subnet-AZ1"
  }
}
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_blocks_public_subnet[1]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[1] 
  tags = {
    Name = "Cloudhight-public-Subnet-AZ2"
  }
}

# Private Subnet AZ1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_blocks_private_subnet[0]
  availability_zone = var.availability_zones[0]  
  tags = {
    Name = "Cloudhight-Private-Subnet-AZ1"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_blocks_private_subnet[1]
  availability_zone = var.availability_zones[1]  
  tags = {
    Name = "Cloudhight-Private-Subnet-AZ1"
  }
}
# Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Cloudhight-Public-RT1"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Route Table for Private Subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Cloudhight-Private-RT1"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id
}

# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}


# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route" "private_nat_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.nat_gateway.id
}


# Security Group
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for the ALB
resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Security group for the ALB"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance in the Public Subnet
resource "aws_instance" "Clt_public" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_az1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_web.id]
  key_name                    = "Cloudhight"
  tags = {
    Name = "Cloudhight-jump-server"
  }
}

# EC2 Instance in the Private Subnet
resource "aws_instance" "Clt_private" {
  ami                    = var.ami
  instance_type          = var.instance_type
  user_data              = file("user-data.sh")
  subnet_id              = aws_subnet.private_subnet_az1.id
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name               = "Cloudhight"
  
  tags = {
    Name = "Docker-host-server"
  }
}

# EBS Volume for Private EC2 Instance
resource "aws_ebs_volume" "private_instance_volume" {
  availability_zone = aws_instance.Clt_private.availability_zone
  size              = 8
  tags = {
    Name = "Cloudhight-Private-Instance-Volume1"
  }
}

# Attach EBS Volume to Private EC2 Instance
resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.private_instance_volume.id
  instance_id = aws_instance.Clt_private.id
}
