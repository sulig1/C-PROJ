resource "aws_lb" "tc_alb" {
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

resource "aws_lb_target_group" "tc-target-group" {
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

#listener for HTTP
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

#Cloudwatch 

resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/ecs-app"
  retention_in_days = 7
}

#IAM Execution Role

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


#ECS cluster
resource "aws_ecs_cluster" "main" {
  name = "ecs-cluster-main"
}

#ECS task definition
resource "aws_ecs_task_definition" "app" {
  family                   = "ecs-threat-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"   # 0.25 vCPU
  memory                   = "512"   # 512 MB
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "866605741514.dkr.ecr.us-east-2.amazonaws.com/threat-compose-workflow:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      #COME BACK TO THIS

      logConfiguration = {
      logDriver = "awslogs"
      options = {
      awslogs-group         =  aws_cloudwatch_log_group.ecs_app.name
      awslogs-region        = "us-east-2"
      awslogs-stream-prefix = "ecs"
  }
}



    }
  ])
}

# #ECS Service

resource "aws_ecs_service" "app-ecs" {
  name            = "ecs-service-app"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.private1_subnet, var.private2_subnet]
    security_groups = [var.ecs_sg1]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tc-target-group.arn
    container_name   = "my-container"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.listener-https]
}

# Look up your Route 53 hosted zone
data "aws_route53_zone" "sulig" {
  name         = "sulig.click"
  private_zone = false   # since it's a public domain
}

resource "aws_route53_record" "app_domain_link" {
  zone_id = data.aws_route53_zone.sulig.id  # Your hosted zone ID
  name    = "app.sulig.click"                    # Subdomain or root domain
  type    = "A"

  alias {
    name                   = aws_lb.tc_alb.dns_name   # ALB DNS name
    zone_id                = aws_lb.tc_alb.zone_id   # ALB hosted zone ID
    evaluate_target_health = true
  }
}

