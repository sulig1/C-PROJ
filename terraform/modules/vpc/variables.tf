variable "vpc_name" {
    type = string
    default = "my-custom-vpc"
}


variable "public_subnet_AZ" {
    type = string
    default = "us-east-2b"
}


variable "public_subnet_name" {
    type = string
    default = "Public Subnet1"
}


variable "private_subnet_name" {
    type = string
    default = "Private Subnet1"
}


variable "igw_name" {
    type = string
    default = "Custom IGW"
}


variable "public_route_tabel1_name" {
    type = string
    default = "ps-route table"
}


variable "elastic_ip1_name" {
    type = string
    default = "nat-elastic-ip"
}


variable "nat1_name" {
    type = string
    default = "custom-NAT" 
}


variable "private_route_table1_name" {
    type = string
    default = "privat- route table"
}


variable "public_subnet2_AZ" {
    type = string
    default = "us-east-2c"
}


variable "public_subnet2_name" {
    type = string
    default = "Public Subnet2"
}


variable "private_subnet2_name" {
    type = string
    default = "Private Subnet2"
}


variable "public_route_tabel2_name" {
    type = string
    default = "public2-route table" 
}


variable "elastic_ip2_name" {
    type = string
    default = "nat-elastic-ip2"
}


variable "nat_gateway2_name" {
    type = string
    default = "custom-nat2"
}


variable "private_route_table2_name" {
    type = string
    default = "private2-route table"
}


variable "http_port" {
    type = number
    default = 80
}


variable "ingress_cidr_alb_sg" {
    type = list(string)
    default = ["0.0.0.0/0"]
}


variable "https_port" {
    type = number
    default = 443
}


variable "egress_cidr_alb_sg" {
    type = list(string)
    default = ["0.0.0.0/0"]
}


variable "load_balancer_security_group" {
    type = string
    default = "alb-sg"
}


variable "ecs_security_group_name" {
    type = string
    default = "ecs-sg"
}


variable "vpc_cidr" {
    description = "custom vpc cidr"
    type = string 
    default = "10.0.0.0/16"
}


variable "public-cidr1" {
    description = "custom public subnet1 cidr"
    type = string
    default = "10.0.1.0/24"
}


variable "private-cidr1" {
    description = "custom private subnet1 cidr"
    type = string
    default = "10.0.2.0/24"
}


variable "public-cidr2" {
    description = "custom public subnet2 cidr"
    type = string
    default = "10.0.5.0/24"
}


variable "private-cidr2" {
    description = "custom private subnet2 cidr"
    type = string
    default = "10.0.4.0/24"
}

