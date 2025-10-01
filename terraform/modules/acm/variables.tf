variable "name_domain" {
    description = "domain name"
    type = string
    default = "*.sulig.click"
  
}

variable "val_method" {
    description = "acm validation method"
    type = string
    default = "DNS"
  
}

variable "alb_dns" {
    description = "alb dns name"
    type = string
    #uses module
  
}

variable "alb_zoneid" {
    type = string
    #uses module
  
}

variable "hosted_zone_name" {
    type = string
    default = "sulig.click"
  
}

variable "private_zone_check" {
    type = string
    default = "false"
  
}

variable "app_domain_name" {
    type = string
    default = "app.sulig.click"
  
}

variable "record_type" {
    type = string
    default = "A"
  
}

variable "r53_record_ttl" {
    type = string
    default = "60"
 

}



variable "alias_target_health" {
    type = bool
    default = true
  
}