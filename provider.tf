terraform {
  required_version = "1.10.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }

  backend "s3" {
    bucket       = "ecs-terraform"
    region       = "ap-northeast-1"
    key          = "terraform.state"
    use_lockfile = true
  }
}

provider "aws" {
  shared_config_files      = ["/root/.aws/config"]
  shared_credentials_files = ["/root/.aws/credentials"]
  profile                  = "terraform-exec"
  region                   = "ap-northeast-1"
}
