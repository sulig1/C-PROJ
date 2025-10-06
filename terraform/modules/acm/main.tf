resource "aws_acm_certificate" "certification" { 
  domain_name       = var.name_domain 
  validation_method = var.val_method 

  lifecycle {
    create_before_destroy = true 
  }
}



data "aws_route53_zone" "sulig" {            
  name         = var.hosted_zone_name 
  private_zone = var.private_zone_check  
}


resource "aws_route53_record" "app_domain_link" {         
  zone_id = data.aws_route53_zone.sulig.id  
  name    = var.app_domain_name                 
  type    = var.record_type      

  alias {  
    name                   = var.alb_dns   
    zone_id                = var.alb_zoneid  
    evaluate_target_health = var.alias_target_health 
  }
}

resource "aws_route53_record" "val" { 
  for_each = {   
    for dvo in aws_acm_certificate.certification.domain_validation_options : dvo.domain_name => { 
      name   = dvo.resource_record_name 
      record = dvo.resource_record_value 
      type   = dvo.resource_record_type
    }
  }

 

  allow_overwrite = true 
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.r53_record_ttl 
  type            = each.value.type
  zone_id         = data.aws_route53_zone.sulig.zone_id 

}


resource "aws_acm_certificate_validation" "cert-val" { 
  certificate_arn         = aws_acm_certificate.certification.arn  
  validation_record_fqdns = [for record in aws_route53_record.val : record.fqdn] 
}
