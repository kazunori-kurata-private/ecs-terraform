resource "aws_route53_record" "myrecord_ns" {
  allow_overwrite = true
  name            = var.domain
  records         = ["ns-1501.awsdns-59.org.", "ns-1937.awsdns-50.co.uk.", "ns-433.awsdns-54.com.", "ns-556.awsdns-05.net."]
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.myzone.id
}

resource "aws_route53_record" "myrecord_cname" {
  name    = "_8947fdca8ec3eb7bdb8436a79f367ed0.${var.domain}"
  records = ["_2a1a28d8ac25d50365d712f2fb016f11.zfyfvmchrl.acm-validations.aws."]
  ttl     = 300
  type    = "CNAME"
  zone_id = aws_route53_zone.myzone.id
}

resource "aws_route53_record" "myrecord_soa" {
  allow_overwrite = true
  name            = var.domain
  records         = ["ns-1937.awsdns-50.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  ttl             = 900
  type            = "SOA"
  zone_id         = aws_route53_zone.myzone.id
}

resource "aws_route53_zone" "myzone" {
  comment = "HostedZone created by Route53 Registrar"
  name    = var.domain
}

resource "aws_route53_record" "myrecord_a" {
  name    = var.domain
  type    = "A"
  zone_id = aws_route53_zone.myzone.id
  alias {
    evaluate_target_health = true
    name                   = "dualstack.${aws_lb.bar.dns_name}"
    zone_id                = aws_lb.bar.zone_id
  }
}
