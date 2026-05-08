output "github_actions_role_arn" {
  description = "Paste this value into GitHub repo secrets as AWS_ROLE_ARN"
  value       = aws_iam_role.github_actions.arn
}

output "tfstate_bucket" {
  description = "S3 bucket name for terraform remote state"
  value       = aws_s3_bucket.tf_state.bucket
}

output "tfstate_lock_table" {
  description = "DynamoDB table name for state locking"
  value       = aws_dynamodb_table.tf_lock.name
}