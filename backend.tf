terraform {
  # Configure the backend to store state in an S3 bucket with DynamoDB table for locking
  backend "s3" {
    bucket         = "slowmoose-terraform-state-bucket"
    key            = "iac-terraform/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}