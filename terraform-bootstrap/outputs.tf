output "s3_bucket_name" {
  value = aws_s3_bucket.s3-bucket.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terra-locks.name
}
