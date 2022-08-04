# version/local backend
#
terraform {
  required_version = ">= 1.2"
  backend "local" {
    path = "state/terraform.tfstate"
  }
}

# aws
provider "aws" {
  profile = var.aws_cli_profile
  region  = var.aws_region
}

# module call
module "base" {
  source = "./module/base"

  cidr_vpc = "128.0.0.0/16"

  cidr_subnet = "128.0.1.0/24"

  namespace = "teccle"

  availability_zone = "eu-central-1a"
}
