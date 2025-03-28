# data를 만들어야함
data "aws_route53_zone" "primary" {
    name = "hellomello.site"
    private_zone = false
}

resource "aws_route53_record" "primary" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name = "stage.hellomello.site"
    type = "A"

    alias {
        name = var.alb_dns_name
        zone_id = var.alb_zone_id
        evaluate_target_health = true # health check
    }
} 