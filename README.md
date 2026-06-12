# AWS Infrastructure with Terraform

EC2 server deployment on AWS using Infrastructure as Code.

## What it creates
- EC2 instance (t3.micro — free tier)
- Security group (SSH access)
- SSH key pair

## Usage
```bash
terraform init
terraform plan
terraform apply
ssh -i ~/.ssh/monitor-key ubuntu@$(terraform output server_ip)
terraform destroy  # when done — avoid charges
```

## Stack
Terraform · AWS EC2 · Ubuntu 22.04
