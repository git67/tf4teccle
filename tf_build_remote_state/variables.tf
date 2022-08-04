# aws profile/aws regions aa
variable "profile" {
  type        = string
  description = "profile aws-cli"
  default     = "devops"
}
variable "region" {
  type        = string
  description = "region aws-cli"
  default     = "eu-central-1"
}

