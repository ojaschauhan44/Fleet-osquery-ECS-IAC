resource "aws_route53_zone" "dogfood_fleetdm_com" {
  name = var.domain_fleetdm
}

resource "aws_route53_record" "dogfood_fleetdm_com" {
  zone_id = aws_route53_zone.dogfood_fleetdm_com.zone_id
  name    = var.domain_fleetdm
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = false
  }
}

/*resource "aws_acm_certificate" "dogfood_fleetdm_com" {
  domain_name       = "tpsec.co"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
} */

module "acm_request_certificate" {
  source                            = "git::https://github.com/cloudposse/terraform-aws-acm-request-certificate.git?ref=tags/0.16.0"
  domain_name                       = "tpsec.co"
  process_domain_validation_options = true
  ttl                               = "300"
  subject_alternative_names         = ["*.tpsec.co"]

  tags = var.tags
}


/*resource "aws_route53_record" "dogfood_fleetdm_com_validation" {
  for_each = {
    for dvo in module.acm_request_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = "Z05367022ACAXM4B9ENFQ"
}

resource "aws_acm_certificate_validation" "dogfood_fleetdm_com" {
  certificate_arn         = module.acm_request_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.dogfood_fleetdm_com_validation : record.fqdn]
}
*/