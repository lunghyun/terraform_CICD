output "alb_dns_name" {
    value = aws_lb.webserver_alb.dns_name
    description = "Domain name of ALB"
}

output "alb_zone_id" {
    value = aws_lb.webserver_alb.zone_id
}