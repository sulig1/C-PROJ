resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public-cidr1
  availability_zone = var.public_subnet_AZ

  tags = {
    Name = var.public_subnet_name
  }
}


resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private-cidr1
  availability_zone = var.public_subnet_AZ

  tags = {
    Name = var.private_subnet_name
  }
}


resource "aws_internet_gateway" "gw" { 
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw_name
  }
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.public_route_tabel1_name
  }
}


resource "aws_route" "rt-route" {
  route_table_id            = aws_route_table.public-rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.gw.id
}


resource "aws_route_table_association" "psubnet-assc" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_eip" "nat_eip" {
  domain = "vpc"  
  tags = {
    Name = var.elastic_ip1_name
  }
}


resource "aws_nat_gateway" "NAT" {
  connectivity_type = "public"
  allocation_id     =  aws_eip.nat_eip.id 
  subnet_id         = aws_subnet.public-subnet.id

  tags = {
    Name = var.nat1_name
  }
}


resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.private_route_table1_name
  }
}


resource "aws_route" "private-rt-route" {
  route_table_id            = aws_route_table.private-rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.NAT.id
}


resource "aws_route_table_association" "prvt-subnet-assc" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rt.id
}


resource "aws_subnet" "public-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public-cidr2
  availability_zone       = var.public_subnet2_AZ

  tags = {
    Name = var.public_subnet2_name
  }
}


resource "aws_subnet" "private-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private-cidr2
  availability_zone       = var.public_subnet2_AZ

  tags = {
    Name = var.private_subnet2_name
  }
}


resource "aws_route_table" "public2-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.public_route_tabel2_name
  }
}


resource "aws_route" "public2-rt-route" {
  route_table_id            = aws_route_table.public2-rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.gw.id
}


resource "aws_route_table_association" "psubnet2-assc" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public2-rt.id
}


resource "aws_eip" "nat_eip2" {
  domain = "vpc"   
  tags = {
    Name = var.elastic_ip2_name
  }
}


resource "aws_nat_gateway" "NAT-g2" {
  connectivity_type = "public"
  allocation_id     =  aws_eip.nat_eip2.id
  subnet_id         = aws_subnet.public-subnet2.id

  tags = {
    Name = var.nat_gateway2_name
  }
}


resource "aws_route_table" "private2-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.private_route_table2_name
  }
}


resource "aws_route" "private2-rt-route" {
  route_table_id            = aws_route_table.private2-rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.NAT-g2.id
}


resource "aws_route_table_association" "private2-subnet-assc" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private2-rt.id
}


resource "aws_security_group" "alb_sg" {
  name        = "SG for ALB"
  vpc_id      = aws_vpc.vpc.id

  
  ingress {
    description      = "Allow HTTP traffic"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    cidr_blocks      = var.ingress_cidr_alb_sg
  }

  ingress {
    description      = "Allow HTTPS traffic"
    from_port        = var.https_port
    to_port          = var.https_port
    protocol         = "tcp"
    cidr_blocks      = var.ingress_cidr_alb_sg
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" 
    cidr_blocks      = var.egress_cidr_alb_sg
  }

  tags = {
    Name = var.load_balancer_security_group
  }
}


resource "aws_security_group" "ecs_sg" {
  name        = "SG for ECS"
  vpc_id      = aws_vpc.vpc.id

  
  ingress {
    description      = "Allows traffic from ALB"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"  
    cidr_blocks      = var.egress_cidr_alb_sg
  }

  tags = {
    Name = var.ecs_security_group_name
  }
}


























