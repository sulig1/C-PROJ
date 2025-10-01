variable "cloudwatch_log_group_name" {
    type = string
    default = "/ecs/ecs-app"
  
}



variable "task_def_family" {
    type = string
    default = "ecs-threat-app"
  
}

variable "task_def_network_mode" {
    type = string
    default = "awsvpc"
  
}

variable "task_def_rq" {
    description = "ecs task definition requires_compatibilities"
    type = list(string)
    default = ["FARGATE"]
  
  
}

variable "task_def_cpu" {
    type = number
    default = 256
  
}

variable "task_def_memory" {
    type = number
    default = 512
  
}



variable "ecs_cluster_name" {
    type = string
    default =  "ecs-cluster-main"
  
}

variable "exec_r_arn" {
    description = "execution role arn"
    type = string
  
}

variable "ecr_uri" {
    description = "the uri for the ecr repo"
    type = string
    default = "866605741514.dkr.ecr.us-east-2.amazonaws.com/threat-compose-workflow"

}

variable "port_number" {
    type = number
    description = "port number for my application"
    default = 3000
    
  
}

variable "ecs-serv-name" {
    description = "ecs service name"
    type = string
    default = "ecs-service-app"
    
  
}

variable "launch_type" {
    description = "ecs launch type"
    type = string
    default = "FARGATE"
    
  
}

variable "pv_subnet_1" {  #uses modules
    type = string

  
}

variable "pv_subnet_2" {   #uses modules
    type = string
  
}

variable "ecs_sg1" {     #uses modules
    type = string
  
}

variable "target_group_arn" {   #uses modules
    type = string
  
}

variable "container_name" {
    type = string
    description = "ecs container name"
    default = "my-container"
    
  
}

variable "alb_Listener" {  #uses module
    type = any
  
}

variable "log_region" {
    description = "aws log region"
    type = string
    default = "us-east-2"
  
}