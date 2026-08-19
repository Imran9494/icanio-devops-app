variable "aws_region" {
  description = "AWS region for the assessment infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix used for assessment resources"
  type        = string
  default     = "icanio-devops"
}