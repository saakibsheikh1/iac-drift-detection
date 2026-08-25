terraform {
  backend "s3" {
    bucket       = "iac-drift-tfstate-503718"
    key          = "iac-drift-detection/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}