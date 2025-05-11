# AWS-K8-TF: Full Stack Application on AWS EKS with Terraform and GitHub Actions

This project deploys a full-stack application to AWS using Kubernetes and Infrastructure as Code with Terraform. It uses GitHub Actions for CI/CD, deploying a React frontend and Java Spring Boot backend connected to a PostgreSQL database.

---

## 🛠️ Architecture

```
+----------------+         +--------------------+
|    Internet    |  --->   | AWS ALB (Ingress)  |
+----------------+         +--------------------+
                                  |
                   +--------------+
                   |
          +----------------+            +----------------+
          |  K8S Ingress   | +--------+ |  K8S Service   |
          +----------------+            +----------------+
                                                |
                   +----------------------------+
                   |
          +----------------+            +----------------+
          | Frontend Pods  | +--------+ |  Backend Pods  |
          +----------------+            +----------------+
                                                  |
                                           +----------------+
                                           | RDS (Postgres) |
                                           +----------------+
```

## 🧱 Project Structure

```
AWS-K8-TF/
├── .github/workflows/           
│   ├── deploy.yml               
│   └── e2e.yml                  
├── frontend/                    
│   ├── Angular
├── backend/                     
│   ├── Java
├── terraform/                   
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── apply-tfvars/
│   └── modules/
│       ├── vpc/
│       ├── eks/
│       ├── rds/
│       ├── alb/
│       ├── bastion/
│       ├── state/
│       └── watch/
└── README.md                    
```

---

## 🚀 Features

- **Modular Terraform Infrastructure** for EKS, VPC, ALB, RDS, and IAM.
- **GitHub Actions CI/CD** for both backend and frontend pipelines.
- **Helm Charts** for deploying frontend and backend to EKS.
- **ALB Ingress + Route53** for DNS-based access via `app.muratyurtdas.com`.
- **PostgreSQL RDS** with persistent storage.
- **Secrets Management** via Terraform for sensitive data.
- **HPA Support** via Helm templates.

---

## 📦 Deploy Instructions

### Prerequisites

- AWS CLI & credentials
- Terraform CLI
- Docker & GitHub CLI
- kubectl & helm

### Setup

1. Clone:

```bash
git clone https://github.com/TheMuyu/AWS-K8-TF.git && cd AWS-K8-TF
```

2. Configure your `.tfvars` file in `terraform/apply-tfvars/dev.tfvars`.

3. Deploy infrastructure:

```bash
cd terraform
terraform init
terraform apply -var-file="apply-tfvars/dev.tfvars"
```

4. Connect `kubectl`:

```bash
aws eks --region eu-central-1 update-kubeconfig --name <cluster-name>
```

5. Deploy app via Helm:

```bash
helm upgrade --install backend ./backend
helm upgrade --install frontend ./frontend
```

---

## 🛠 CI/CD with GitHub Actions

Workflows:
- `deploy.yml`: Provisions infra, builds Docker images, deploys Helm charts.
- `e2e.yml`: Waits on `deploy.yml` and runs integration tests.

Features:
- Ingress hostname extraction
- Auto Route53 ALIAS record creation
- Robust error handling with retries

---

## 🔐 Secrets and ALB Ingress

- ALB hostname is dynamically fetched after deployment.
- Route53 record is created in workflow (not in Terraform) to prevent destroy delays.

---

## 📄 License

MIT License

---

For contributions, issues, or enhancements, feel free to open a PR or issue.
