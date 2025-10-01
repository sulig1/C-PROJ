resource "aws_lb" "tc_alb" {          
  name               = "tc-alb"
  internal           = false                     
  load_balancer_type = var.lb_type   
  subnets = [var.public_subnet_id, var.public_subnet2_id]
  security_groups    = [var.alb_sg1]

  enable_deletion_protection = false 

  tags = {
    Name = "tc-alb"
  }
}




resource "aws_lb_target_group" "tc-target-group" {  
  name     = "ecs-tg" 
  port     = var.port1 
  protocol = var.protocol1 
  vpc_id   = var.tg1
  target_type = "ip"

  health_check { 
    path                = "/" 
    interval            = 30  
    timeout             = 5   
    healthy_threshold   = 2   
    unhealthy_threshold = 2  
    matcher             = "200-399" 
  }
}




resource "aws_lb_listener" "listener-https" {     
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


resource "aws_lb_listener" "listener-http" {         
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




