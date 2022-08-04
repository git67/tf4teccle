variable "namespace" {
  description = "part of naming schema"
  default     = "NONE"
}
variable "cidr_vpc" {
  description = "cidr vpc"
  default     = "0.0.0.0/8"
}
variable "cidr_subnet" {
  description = "cidr subnet"
  default     = "0.0.0.0/24"
}
variable "availability_zone" {
  description = "av-zone subnet"
  default     = "NONE"
}
