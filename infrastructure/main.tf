module "network" {
  source = "./modules/network"

  name        = var.project_name
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

module "security" {
  source = "./modules/security"

  name        = var.project_name
  environment = var.environment
  vpc_id      = module.network.vpc_id
  app_port    = var.app_port
}

module "compute" {
  source = "./modules/compute"

  name               = var.project_name
  environment        = var.environment
  ami_id             = "ami-0f918f7e67a3323f0"
  instance_type      = var.instance_type
  subnet_id          = module.network.public_subnet_ids[0]
  security_group_ids = [module.security.app_security_group_id]
  key_name           = "blue - green key"

  associate_public_ip = true

  user_data = <<-EOF
#!/bin/bash
set -eux

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

rm -rf /var/lib/apt/lists/*
apt-get clean

while ! apt-get update; do
    echo "Waiting for apt repositories..."
    sleep 10
done

while ! DEBIAN_FRONTEND=noninteractive apt-get install -y nginx; do
    echo "Refreshing package lists..."
    rm -rf /var/lib/apt/lists/*
    apt-get clean
    apt-get update
    sleep 10
done

systemctl enable nginx
systemctl restart nginx

echo "IaC Drift Detection Application" > /var/www/html/index.html

echo "Nginx bootstrap completed."
EOF
}

module "load_balancer" {
  source = "./modules/load-balancer"

  name               = var.project_name
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  security_group_ids = [module.security.alb_security_group_id]
  target_port        = var.app_port
  health_check_path  = "/"
  target_instance_id = module.compute.instance_id
}