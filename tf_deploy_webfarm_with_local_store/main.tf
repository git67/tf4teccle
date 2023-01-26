# version/local backend 
#
terraform {
  required_version = ">= 0.12"
  backend "local" {
    path = "state/terraform.tfstate"
  }
}

# aws client
provider "aws" {
  profile = var.profile
  region  = var.region
}

# module call
module "stack" {
  source   = "./module/stack"
  vpc_cidr = "128.0.0.0/16"

  subnet_cidrs = ["128.0.1.0/24", "128.0.2.0/24", "128.0.3.0/24"]
  av_zones     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

  namespace = "teccle"

  ec2 = {
    "instance_ami"   = "ami-0a02ee601d742e89f"
    "instance_type"  = "t2.nano"
    "instance_count" = 2
    "ebs_device"     = "/dev/sdb"
    "ebs_vol_size"   = 1
    "ebs_vol_type"   = "gp2"
  }

  ssh_credentials = {
    "pub_key"  = "./files/keys/ec2-user.pub"
    "priv_key" = "./files/keys/ec2-user"
  }

}
