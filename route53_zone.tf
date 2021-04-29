resource "aws_route53_zone" "private" {
  name = "execute-api.ap-northeast-1.amazonaws.com"

  vpc {
    vpc_id = aws_vpc.a.id
  }
}

resource "aws_route53_record" "apigw" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "*.execute-api.ap-northeast-1.amazonaws.com"
  type    = "A"

  alias {
    name                   = lookup(aws_vpc_endpoint.apigw.dns_entry[0], "dns_name")
    zone_id                = lookup(aws_vpc_endpoint.apigw.dns_entry[0], "hosted_zone_id")
    evaluate_target_health = true
  }
}
