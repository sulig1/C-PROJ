variable "region" {
    description = "AWS access key"
    default = "us-east-2"
  
}



variable "aws_log_region" {
    type = string
    default = "us-east-2"
  
}




variable "dynamodb_table_name" {
    type = string
    default = "tf-protection-locks"
  
}






