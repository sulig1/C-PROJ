resource "aws_ecs_cluster" "main" {                   
  name = var.ecs_cluster_name
}


resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 7         
}


resource "aws_ecs_task_definition" "app" {            
  family                   = var.task_def_family
  network_mode             = var.task_def_network_mode
  requires_compatibilities = var.task_def_rq 
  cpu                      = var.task_def_cpu  
  memory                   = var.task_def_memory   
  execution_role_arn       = var.exec_r_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.ecr_uri
      essential = true
      portMappings = [
        {
          containerPort = var.port_number
          hostPort      = var.port_number
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
      logDriver = "awslogs"
      options = {
      awslogs-group         = aws_cloudwatch_log_group.ecs_app.name
      awslogs-region        = var.log_region
      awslogs-stream-prefix = "ecs"
  }
}
    }
  ])
  
}


resource "aws_ecs_service" "app-ecs" {          
  name            = var.ecs-serv-name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = var.launch_type

  network_configuration {
    subnets         = [var.pv_subnet_1, var.pv_subnet_2]
    security_groups = [var.ecs_sg1]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.port_number
  }

  depends_on = [var.alb_Listener]
}