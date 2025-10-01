
variable "alb_sg1" {
    description = "alb security group id"
    type = string
  
}

variable "ecs_sg1" {
    type = string
  
}

variable "public_subnet_id" {
    type = string

}

variable "public_subnet2_id" {
    type = string
  
}

variable "lb_type" {
    description = "load balancer type"
    type = string
    default = "application"
  
  
}


variable "tg1" {
    type = string
  
}

variable "port1" {
    description = "target group port"
    type = string
    default = "3000"
  
}

variable "protocol1" {
    description = "target group protocol"
    type = string
    default = "HTTP"
  
}

variable "private1_subnet" {
    type = string
  
}

variable "private2_subnet" {
    type = string
  
}

variable "cert_arn" {
    type = string
  
}

