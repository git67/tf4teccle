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

locals {
 full_json = jsondecode(file("dat.json"))
 from_json = jsondecode(file("dat.json"))["main"]["val"]
 get_element = local.full_json.main.val[*].val1[*].d1
}

output "from_json" {
  value = toset([
	for loop_var in local.from_json: loop_var
  ])
}

output "get_element" {
  value = local.get_element
}
