output "tg_arn" {
    description = "target group arn"
    value = aws_lb_target_group.tc-target-group.arn
}


output "listener" {
    value = aws_lb_listener.listener-http
}


output "alb_dns_name" {
    value = aws_lb.tc_alb.dns_name 
}


output "alb_zone_id" {
    value = aws_lb.tc_alb.zone_id
}