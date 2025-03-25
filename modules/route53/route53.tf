# data를 만들어야함
data "aws_route53_zone" "primary" {
    name = "hellomello.kro.kr"
    private_zone = false
}

resource "aws_route53_record" "api" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name = "api.${var.alb_dns_name}"
    type = "A"

    alias {
        name = aws_lb.webserver_alb.dns_name
        zone_id = aws_lb.webserver_alb.zone_id
        evaluate_target_health = true # health check
    }
}