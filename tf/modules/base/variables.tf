# namespace
variable "namespace" {
  description = "part of used rs names"
  type        = string
  default     = "NONE"
}

# rg
variable "rg_name" {
  description = "name of used rg"
  type        = string
  default     = "NONE"
}


# rg
variable "network_rg_name" {
  description = "name of used rg"
  type        = string
  default     = "RG_TF_NETWORK"
}

# ddos
variable "ddos_protection_plan" {
  description = "name of used ddos_protection_plan"
  type        = string
  default     = "tf_ddos_protection_plan"
}

# location
variable "location" {
  description = "az geo"
  type        = string
  default     = "germanywestcentral"
}

# av zones
variable "av_zones" {
  description = "definition address space vnet"
  type        = list(any)
  default     = ["1","2"]
}

# vnet cidr
variable "vnet_address_space" {
  description = "definition address space vnet"
  type        = list(any)
  default     = ["10.1.0.0/16"]
}

# subnet cidr
variable "subnet_address_prefixes" {
  description = "definition address space subnet"
  type        = list(any)
  default     = ["10.1.0.0/24"]
}

# jumphost subnet cidr
variable "jumphost_net_prefixes" {
  description = "definition address space jumphost subnet"
  type        = list(any)
  default     = ["10.1.1.0/24"]
}

# admin user vm
variable "vm_admin_username" {
  description = "initial admin user"
  type        = string
  default     = "vm_adm"
}

# vm hostname
variable "vm_computer_name" {
  description = "vm hostame"
  type        = string
  default     = "NONE"
}

# vm count
variable "vm_count" {
  description = "count of vm to deploy"
  type        = string
  default     = "1"
}

# http backend port
variable "http_backend_port" {
  description = "backend http port"
  type        = string
  default     = "8080"
}

# https backend port
variable "https_backend_port" {
  description = "backend https port"
  type        = string
  default     = "8443"
}

# http lb port
variable "http_lb_port" {
  description = "load balancer http port"
  type        = string
  default     = "80"
}

# https lb port
variable "https_lb_port" {
  description = "load balancer https port"
  type        = string
  default     = "443"
}

variable "ssh_vault_name" {
  description = "azure vault name"
  type        = string
  default     = "TF-PRIV-KEY"
}

variable "ssh_keys_rg" {
  description = "resource group name for ssh key management"
  type        = string
  default     = "RG_TF_SSH_KEYS"
}

variable "ssh_pubkey_name" {
  description = "azure resource name of ssh pubkey"
  type        = string
  default     = "TF_PUB_KEY"
}

variable "ssh_private_key_name" {
  description = "azure secret name of ssh private key"
  type        = string
  default     = "private-key01"
}
