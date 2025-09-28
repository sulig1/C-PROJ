resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "my-custom-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public-cidr1
  availability_zone = "us-east2b"

  tags = {
    Name = "Public Subnet1"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private-cidr1
  availability_zone = "us-east2b"

  tags = {
    Name = "Private Subnet1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Custom IGW"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ps-route table"
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
  domain = "vpc"   # Required when using VPC-based NAT Gateways
  tags = {
    Name = "nat-elastic-ip"
  }
}




resource "aws_nat_gateway" "NAT" {
  connectivity_type = "public"
  allocation_id     =  aws_eip.nat_eip.id 
  subnet_id         = aws_subnet.public-subnet.id

  tags = {
    Name = "custom-NAT"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "privat- route table"
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

resource "aws_security_group" "alb_sg" {
  name        = "SG for ALB"
  vpc_id      = aws_vpc.vpc.id

  
  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    description      = "Allow HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" 
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
    Name = "alb-sg"
  }
}


resource "aws_security_group" "ecs_sg" {
  name        = "SG for ECS"
  vpc_id      = aws_vpc.vpc.id

  
  ingress {
    description      = "Allows traffic from ALB"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  #outbound allows all traffic as ecs needs to communicate with NAT/Internet
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" #-1 is a special value that means all protocols.  
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
    Name = "ecs-sg"
  }
}


























#Creating PublicSubnet2 and PrivateSubnet 2 for new AZ

resource "aws_subnet" "public-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public-cidr2
  availability_zone       = "us-east-2c"

  tags = {
    Name = "Public Subnet2"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private-cidr2
  availability_zone       = "us-east-2c"

  tags = {
    Name = "Private Subnet2"
  }
}

#Creating Route Table for PublicSubnet2
resource "aws_route_table" "public2-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public2-route table"
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


#creating second elastic IP for second NAT gateway
resource "aws_eip" "nat_eip2" {
  domain = "vpc"   # Required when using VPC-based NAT Gateways
  tags = {
    Name = "nat-elastic-ip2"
  }
}


#creating NAT in publicSubnet2 for PrivateSubnet2

resource "aws_nat_gateway" "NAT-g2" {
  connectivity_type = "public"
  allocation_id     =  aws_eip.nat_eip2.id
  subnet_id         = aws_subnet.public-subnet2.id

  tags = {
    Name = "custom-nat2"
  }
}


#Creating RouteTable for PrivateSubnet2

resource "aws_route_table" "private2-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private2- route table"
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