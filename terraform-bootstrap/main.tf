resource "aws_s3_bucket" "s3-bucket" {
    bucket = "tc-terraform-state-sulig"
  
}

resource "aws_s3_bucket_versioning" "s3-bucket-versioning" {
    bucket = aws_s3_bucket.s3-bucket.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_dynamodb_table" "terra-locks" {
    name = "tf-protection-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
  
}


variable "region" {
    description = "AWS access key"
    
}


variable "access_key" {
    description = "AWS access key"
}


variable "secret_key" {
    description = "AWS secret key"
}