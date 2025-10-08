
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
    default = "80"
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


variable "load_balancer_name" {
    type = string 
    default = "tc-alb"
}


variable "alb_target_group_name" {
    type = string
    default = "ecs-tg"
}


variable "alb_target_group_target_type" {
    type = string
    default = "ip"
}


variable "https_listener_port" {
    type = string
    default = "443"
}


variable "https_listener_ssl_policy" {
    type = string
    default = "ELBSecurityPolicy-2016-08"
}


variable "http_listener_port" {
    type = string
    default = "80"
}