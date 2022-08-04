# version/local backend 
#

terraform {
  backend "s3" {
    encrypt                 = true
    bucket                  = "deploy-tf"
    key                     = "state.tf"
    shared_credentials_file = "~/.aws/credentials"
    dynamodb_table          = "tf-locks"
    profile = "devops"
    region  = "eu-central-1"
  }
}

# aws client
provider "aws" {
  profile = var.profile
  region  = var.region
}

# module call
module "stack" {
  source = "./module/stack"

  vpc_cidr = var.vpc_cidr

  subnet_cidrs = var.subnet_cidrs
  av_zones     = var.av_zones

  namespace = var.namespace

  ssh_credentials = var.ssh_credentials

  ec2 = var.ec2
}
