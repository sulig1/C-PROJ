
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
  
}


variable "tg1" {
    type = string
  
}

variable "port1" {
    type = string
  
}

variable "protocol1" {
    type = string
  
}

variable "private1_subnet" {
    type = string
  
}

variable "private2_subnet" {
    type = string
  
}

