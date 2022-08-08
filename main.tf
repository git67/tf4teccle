variable "aws_cli_profile" {
  description = "aws profile"
  default     = "devops"
}

variable "aws_region" {
  description = "aws region"
  default     = "eu-central-1"
}

variable "filter_str" {
  description = "string for filter namespaces"
  default     = "teccle-*"
}


# aws
provider "aws" {
  profile = var.aws_cli_profile
  region  = var.aws_region
}

# vpc
data "aws_vpc" "get_vpc_id" {
  filter {
    name	= "tag:Name"
    values	= [var.filter_str]
  }
}

output "aws_vpc_id" {
  value = data.aws_vpc.get_vpc_id.id
}
