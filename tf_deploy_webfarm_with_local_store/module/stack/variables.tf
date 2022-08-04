# naming
variable "namespace" {
  type        = string
  description = "namespace for building unique name tags"
  default     = "NONE"
}

# ssh stuff
variable "ssh_credentials" {
  description = "ssh key files"
  type        = map(any)
  default = {
    "pub_key"  = "NONE"
    "priv_key" = "NONE"
  }
}

# vpc
variable "vpc_cidr" {
  description = "vpc_cidr"
  default     = "0.0.0.0/8"
}

# subnets (keep in mind the aws elb can't deal with multiple subnets in a av-zone)
variable "subnet_cidrs" {
  description = "pub_subnet_cidrs"
  type        = list(any)
  default     = ["0.0.0.0/8"]
}

# avz
variable "av_zones" {
  description = "used av zones"
  type        = list(any)
  default     = ["NONE"]
}

# ec2
variable "ec2" {
  description = "ec2 attributes"
  type        = map(any)
  default = {
    "instance_ami"   = "NONE"
    "instance_type"  = "NONE"
    "instance_count" = 0
    "ebs_device"     = "NONE"
    "ebs_vol_size"   = 0
    "ebs_vol_type"   = "NONE"
  }
  validation {
    condition     = var.ec2["ebs_vol_size"] > 0
    error_message = "the ebs_vol_size have to larger then 0"
  }
}
