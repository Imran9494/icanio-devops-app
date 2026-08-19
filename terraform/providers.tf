provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "icanio-devops-assessment"
      Environment = "assessment"
      ManagedBy   = "Terraform"
    }
  }
}