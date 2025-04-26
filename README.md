
# AWS-K8-TF

This project automates the deployment of a production-grade AWS infrastructure using Terraform, Kubernetes (EKS), and related AWS services.

## 🚀 Project Overview

- **Terraform** is used as Infrastructure as Code (IaC) to provision:
  - VPC with public and private subnets
  - EKS Cluster (Managed Kubernetes)
  - RDS PostgreSQL database
  - Application Load Balancer (ALB) with Route53 DNS integration
  - IAM Roles, Security Groups
  - CloudWatch monitoring (metrics, logging, alarms)
- **Kubernetes** is used to deploy:
  - Backend Service (Java Spring Boot API)
  - Frontend Service (Angular Application)

## 🛠️ Architecture

```
+----------------+         +--------------------+
|    Internet    |  --->   | AWS ALB (Ingress)  |
+----------------+         +--------------------+
                                  |
                   +--------------+
                   |                             
          +----------------+            +----------------+
          | Frontend Pods  | +--------+ |  Backend Pods  |
          +----------------+            +----------------+
                                                  |
                                           +----------------+
                                           | RDS (Postgres) |
                                           +----------------+
```

## 📋 Prerequisites

- AWS Account
- Route53 Hosted Zone
- Domain (e.g., muratyurtdas.com)
- AWS CLI configured
- kubectl installed
- Terraform v1.5+
- Helm v3+
- Docker installed (for building images)

## 📂 Project Structure

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── modules/
│   ├── alb/
│   ├── eks/
│   ├── rds/
│   └── vpc/
.github/
├── workflows/
│   └── deploy.yml  (GitHub Actions for CI/CD)
k8s/
├── backend/
│   ├── deployment.yaml
│   ├── service.yaml
├── frontend/
│   ├── deployment.yaml
│   ├── service.yaml
```

## ⚙️ Deployment

1. **Clone the Repository**
   ```bash
   git clone https://github.com/TheMuyu/AWS-K8-TF.git
   cd AWS-K8-TF/terraform
   ```

2. **Terraform Initialization**
   ```bash
   terraform init
   ```

3. **Terraform Plan and Apply**
   ```bash
   terraform plan
   terraform apply
   ```

4. **Deploy Applications to EKS**
   - Update `k8s/backend/deployment.yaml` and `k8s/frontend/deployment.yaml` with Docker image paths.
   - Apply Kubernetes manifests:
   ```bash
   kubectl apply -f k8s/backend/
   kubectl apply -f k8s/frontend/
   ```

5. **Set up Domain DNS (Route53)**
   - ALB DNS is automatically registered via Terraform.
   - Confirm your `app.muratyurtdas.com` (or other subdomain) points correctly.

6. **Monitor Logs and Metrics**
   - CloudWatch integration enabled for pods, nodes, and services.
   - CloudWatch Alarms notify critical issues via SNS.

## 🛡️ Security Highlights

- Backend and RDS only accessible within private subnets.
- Secrets stored securely in AWS Secrets Manager.
- IAM roles and policies follow least privilege principles.

## 📜 License

This project is licensed under the MIT License.

---

> Made with ❤️ using AWS, Kubernetes, Terraform and DevOps best practices.
