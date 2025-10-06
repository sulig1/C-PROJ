

resource "aws_iam_role" "ecs_task_execution" {            
  name = "ecsTaskExecutionRole" #This defiens an IAM role called ecsTaskExecutionRole

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole" #is the API call AWS uses to let a service or user “take on” the role’s permissions.
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {        
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


#Creating an IAM Role for ECS tasks
#This defiens an IAM role called ecsTaskExecutionRole
#Roles are like temporary "identities" that AWS services can assume to perform actions

#Trust Policy (Assume Role Policy)
#The JSON block says "I allow ECS tasks (ecs-tasks.amazonaws.com) to assume this role"
#without this, ECS tasks wouldnt be able to use this role 
#is the API call AWS uses to let a service or user “take on” the role’s permissions.

#now, ECS tasks are trusted to become this role when running

#Attaching a Policy to the Role
#This attaches AWS's managed policy called "AmazonECSTaskExecutionRolePolicy" to the role
#That policy gives ECS tasks the permission they need to run, such as:
 #Pulling container images from ECR
 #Writing logs to CkoudWatch
