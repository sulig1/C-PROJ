resource "aws_acm_certificate" "certification" {
  domain_name       = var.name_domain
  validation_method = var.val_method

  lifecycle {
    create_before_destroy = true
  }
}


# Look up your Route 53 hosted zone
data "aws_route53_zone" "sulig" {             #R53
  name         = var.hosted_zone_name
  private_zone = var.private_zone_check  # since it's a public domain
}

#MOVE THIS TO ACM
resource "aws_route53_record" "app_domain_link" {            #R53
  zone_id = data.aws_route53_zone.sulig.id  # Your hosted zone ID
  name    = var.app_domain_name                   # Subdomain or root domain
  type    = var.record_type

  alias {
    name                   = var.alb_dns   # ALB DNS name
    zone_id                = var.alb_zoneid   # ALB hosted zone ID
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

 

  allow_overwrite = true #Lets Terraform overwrite an existing record with the same name if it already exists.
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.r53_record_ttl
  type            = each.value.type
  zone_id         = data.aws_route53_zone.sulig.zone_id

}


resource "aws_acm_certificate_validation" "cert-val" {
  certificate_arn         = aws_acm_certificate.certification.arn #What is arn??? 
  validation_record_fqdns = [for record in aws_route53_record.val : record.fqdn]
}
