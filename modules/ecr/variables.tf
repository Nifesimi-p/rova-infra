variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "allowed_pull_arns" {
  description = "List of IAM ARNs allowed to pull images from this repository"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}