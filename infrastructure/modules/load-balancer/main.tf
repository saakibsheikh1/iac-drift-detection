resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = var.security_group_ids
  subnets         = var.public_subnet_ids

  tags = {
    Name        = "${var.name}-alb"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.name}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name        = "${var.name}-tg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_instance_id
  port             = var.target_port
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
