variable "name" {
  description = "Name prefix for the load balancer"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for the ALB"
  type        = list(string)
}

variable "target_instance_id" {
  description = "EC2 instance ID to attach to the target group"
  type        = string
}

variable "target_port" {
  description = "Port on which the application is running"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "HTTP health check path"
  type        = string
  default     = "/"
}
