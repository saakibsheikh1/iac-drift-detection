resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-alb-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group" "app" {
  name        = "${var.name}-app-sg"
  description = "Security group for application instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Application traffic from ALB"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-app-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
