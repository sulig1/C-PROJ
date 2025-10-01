variable "region" {
    description = "AWS access key"
    default = "us-east-2"
  
}



variable "aws_log_region" {
    type = string
    default = "us-east-2"
  
}

variable "s3_bucket_name" {
    type = string
    default = "tc-terraform-state-sulig"
  
}

variable "s3_key" {
    type = string
    default = "threatcomposer/terraform.tfstate" #path of where it will be stored
  
}

variable "dynamodb_table_name" {
    type = string
    default = "tf-protection-locks"
  
}






# variable "task_def_cpu" {
#     type = string
#     default = "256"
  
# }

# variable "task_def_memory" {
#     type = string
#     default = "512"
  
# }