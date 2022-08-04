output "vpc" {
  description = "vpc id"
  value       = module.base.vpc
}

output "vpc-info" {
  value = module.base.vpc-info
}
