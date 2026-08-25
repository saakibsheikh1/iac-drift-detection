variable "name" {
  description = "Name prefix for the security groups"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 80
}
