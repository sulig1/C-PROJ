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

