resource "aws_acm_certificate" "certification" { #requests an AWS Certificate Manager (ACM) SSL/TLS certificate for a domain.
  domain_name       = var.name_domain #Specifies the domain you want to secure. This comes from a variable.
  validation_method = var.val_method #Determines how AWS validates domain ownership (DNS or EMAIL). Usually, DNS is used in automation.

  lifecycle {
    create_before_destroy = true #Ensures Terraform creates a new certificate before deleting an old one, avoiding downtime.
  }
}



data "aws_route53_zone" "sulig" {     #fetches an existing Route 53 hosted zone        
  name         = var.hosted_zone_name #Looks up the hosted zone by its domain name (e.g., sulig.click)
  private_zone = var.private_zone_check  #Boolean to filter private vs. public hosted zones.
}


resource "aws_route53_record" "app_domain_link" {     #Creates a DNS record in Route 53 to point your domain to an AWS resource (like an ALB).        
  zone_id = data.aws_route53_zone.sulig.id  #Uses the hosted zone ID you looked up earlier.
  name    = var.app_domain_name        #The subdomain (e.g., app.sulig.click).          
  type    = var.record_type       #record type A

  alias {  #specific to AWS. It allows pointing a domain to an AWS resource without paying for Route 53 query costs for standard A/CNAME records.
    name                   = var.alb_dns   #The ALB DNS name to point to. This i got using modules (alb)
    zone_id                = var.alb_zoneid   #The hosted zone ID of the ALB.This i got using modules (alb)
    evaluate_target_health = var.alias_target_health #Whether Route 53 should consider the ALB’s health when resolving DNS.I used true
  }
}

resource "aws_route53_record" "val" { #Automatically creates DNS validation records required for ACM to validate your domain when using DNS validation.
  for_each = {   #for_each allows Terraform to handle multiple validation records if ACM requires them (for SAN certificates or multiple domains).
    for dvo in aws_acm_certificate.certification.domain_validation_options : dvo.domain_name => { #for_each loops over aws_acm_certificate.certification.domain_validation_options. Each domain gets its DNS record: name, record, type
      name   = dvo.resource_record_name #The record name provided by ACM
      record = dvo.resource_record_value #The value ACM expects.
      type   = dvo.resource_record_type #Usually CNAME
    }
  }

 

  allow_overwrite = true #Ensures Terraform can update the record if it already exists.
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.r53_record_ttl #TTL for the record (how long DNS caches it)
  type            = each.value.type
  zone_id         = data.aws_route53_zone.sulig.zone_id #uses your hosten zone to place the record

}


resource "aws_acm_certificate_validation" "cert-val" { #Tells AWS ACM to complete the certificate validation using the DNS records you created in the previous step.
  certificate_arn         = aws_acm_certificate.certification.arn  #References the certificate to validate.
  validation_record_fqdns = [for record in aws_route53_record.val : record.fqdn] #Collects the FQDNs of all DNS validation records created earlier, so ACM can validate them automatically.
}
