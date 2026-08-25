# IaC Drift Detection & Deployment Guardrails

Automated Terraform infrastructure drift detection, remediation, and deployment guardrails for AWS.

## Project Overview

This project demonstrates how Infrastructure as Code (IaC) can be used to detect and manage configuration drift between Terraform configuration and live AWS infrastructure.

The project includes:

- Terraform-managed AWS infrastructure
- Remote Terraform state stored in Amazon S3
- Automated drift detection using PowerShell
- Terraform-based drift remediation
- Deployment guardrail that blocks deployment when unresolved drift exists
- GitHub Actions scheduled drift detection
- GitHub OIDC authentication with AWS IAM
- Evidence-based validation of drift detection and remediation

## Architecture

```text
                    GitHub Repository
                           |
                           v
                  GitHub Actions
                           |
                    GitHub OIDC
                           |
                           v
                 AWS IAM Role
                           |
                           v
                    Terraform
                    /        \
                   /          \
                  v            v
             S3 Backend     AWS Infrastructure
                  |          /    |      \
                  |         /     |       \
                  |       VPC     EC2      ALB
                  |               |
                  |               v
                  |          Security Groups
                  |
                  v
              Terraform State

Repository Structure

iac-drift-detection/
│
├── .github/
│   └── workflows/
│       └── drift-detection.yml
│
├── infrastructure/
│   ├── backend.tf
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── modules/
│       ├── compute/
│       ├── load-balancer/
│       ├── network/
│       └── security/
│
├── drift-scan/
│   └── drift-check.ps1
│
├── remediation/
│   └── remediate.ps1
│
├── deployment-guard.ps1
├── .gitignore
└── README.md
