variable "region" {
    description = "AWS access key"
    default = "us-east-2"
  
}

variable "cidr-vpc" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "cidr-public1" {
    type = string
    default = "10.0.1.0/24"
  
}

variable "cidr-private1" {
    type = string
    default = "10.0.2.0/24"
  
}

variable "cidr-public2" {
    type = string
    default = "10.0.5.0/24"
  
}

variable "cidr-private2" {
    type = string
    default = "10.0.4.0/24"
  
}

variable "domain-name" {
    type = string
    default = "*.sulig.click" #why? in case i need to use like app.sulig.click etc
  
}

variable "acm-vald-method" {
    type = string
    default = "DNS"
  
}

variable "load-bal-type" {
    type = string
    default = "application"
  
}

variable "tg1-port" {
    type = string
    default = "3000"
  
}

variable "tg1-protocol1" {
    type = string
    default = "HTTP"
  
}

