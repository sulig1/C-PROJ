terraform {
  backend "s3" {
    bucket         = "tc-terraform-state-sulig"
    key            = "threatcomposer/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-protection-locks"
    encrypt        = true
  }
}