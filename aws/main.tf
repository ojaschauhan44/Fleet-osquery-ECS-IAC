variable "region" {
  default = "eu-west-2"
}

provider "aws" {
  region  = var.region
  #access_key = "ASIA25KZZZBK6WD7XS4H"
  #secret_key = "JABxvUIN0cXNqZ6qcR4mn0yhz3MC/qSVdz0BYCrY"
  #shared_credentials_files  = ["~/.aws/config"]
  shared_config_files = ["/Users/ojasvi/.aws/config"]
  profile = var.profile
}
provider "tls" {
  # Configuration optionsƒ
}
terraform {
  // these values should match what is bootstrapped in ./remote-state
  backend "s3" {
    bucket         = "abc-fleet-terraform-remote-state"
    region         = "eu-west-2"
    key            = "fleet"
    dynamodb_table = "abc-fleet-terraform-state-lock"
    profile        = "Administrator"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
  }
}
data "aws_caller_identity" "current" {}
