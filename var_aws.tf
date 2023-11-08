# aws profile/aws regions
variable "profile" {
  type        = string
  description = "profile aws-cli"
  default     = "<your profile>"
}
variable "region" {
  type        = string
  description = "region aws-cli"
  default     = "eu-central-1"
}
