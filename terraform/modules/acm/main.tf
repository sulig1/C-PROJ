resource "aws_acm_certificate" "certification" {
  domain_name       = var.name_domain
  validation_method = var.val_method

  lifecycle {
    create_before_destroy = true
  }
}


 data "aws_route53_zone" "example" {
  name         = "sulig.click"
  private_zone = false
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
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.example.zone_id

}


resource "aws_acm_certificate_validation" "cert-val" {
  certificate_arn         = aws_acm_certificate.certification.arn #What is arn??? 
  validation_record_fqdns = [for record in aws_route53_record.val : record.fqdn]
}
