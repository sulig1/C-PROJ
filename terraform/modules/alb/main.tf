resource "aws_lb" "tc_alb" {          #ALB
  name               = "tc-alb"
  internal           = false                     # false = internet-facing, true = internal
  load_balancer_type = var.lb_type                          
  security_groups    = [var.alb_sg1]
  subnets            = [var.public_subnet_id, var.public_subnet2_id] # public subnet1 and add public subnet 2

  enable_deletion_protection = false 

  tags = {
    Name = "tc-alb"
  }
}


#target group 

resource "aws_lb_target_group" "tc-target-group" {   #ALB
  name     = "ecs-tg" 
  port     = var.port1 #3000
  protocol = var.protocol1 #http
  vpc_id   = var.tg1
  target_type = "ip"

  health_check { 
    path                = "/" #checks the root of app, if app has /health endpoint, it can be changed
    interval            = 30  #how often (seconds) the ALB sends health check requests. 30secs gives the app breathing toom without spamming health checks
    timeout             = 5   #how long it waits for a response.if your app takes longer than 5s to respond, it’s marked as failing.
    healthy_threshold   = 2   #how many successful checks before marking a target as healthy.after 2 good responses, the target is marked healthy.
    unhealthy_threshold = 2   #how many failed checks before marking a target as unhealthy.after 2 failed responses, it’s marked unhealthy (good for failover).
    matcher             = "200-399" #which HTTP status codes count as “healthy.”treats success responses (200 OK, 302 redirect, etc.) as healthy.
  }
}



#listener for HTTPS
resource "aws_lb_listener" "listener-https" {     #ALB
  load_balancer_arn = aws_lb.tc_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tc-target-group.arn
  }
}

#listener for HTTP
resource "aws_lb_listener" "listener-http" {         #ALB
  load_balancer_arn = aws_lb.tc_alb.arn
  port              = "80"
  protocol          = "HTTP"
 
  default_action {
    type             = "redirect"
    
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}




#DELETE THIS

# # Look up your Route 53 hosted zone
# data "aws_route53_zone" "sulig" {             #R53
#   name         = "sulig.click"
#   private_zone = false   # since it's a public domain
# }


# #MOVE THIS TO ACM - REMOVE THIS ONE. I ALREADY HAVE THIS IN ACM
# resource "aws_route53_record" "app_domain_link" {            #R53
#   zone_id = data.aws_route53_zone.sulig.id  # Your hosted zone ID
#   name    = "app.sulig.click"                    # Subdomain or root domain
#   type    = "A"

#   alias {
#     name                   = aws_lb.tc_alb.dns_name   # ALB DNS name
#     zone_id                = aws_lb.tc_alb.zone_id   # ALB hosted zone ID
#     evaluate_target_health = true
#   }
# }

