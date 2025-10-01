# AWS ECS Deployment

This project provisions and deploys a containerised web application (Thread Composer) on AWS ECS Fargate, using Infrastructure as Code  and automated CI/CD pipelines with GitHub Actions.

The application runs securely in private subnets, exposed to the internet only through an Application Load Balancer  with HTTPS enabled via AWS Certificate Manager.

---

## Architecture Overview

### VPC
- Custom VPC with public and private subnets across multiple AZs for high availability.  
- Internet Gateway attached for outbound traffic.  
- NAT Gateways allow ECS tasks in private subnets to securely make outbound connections to the internet.  

---

### Networking & Security
- **Public subnets:** Host the ALB.  
- **Private subnets:** Host ECS Fargate tasks.  
- **Security Groups:** Restrict inbound/outbound traffic to least-privilege rules.  
- **Route Tables** manage isolation between public and private networks.    

---

### Application Load Balancer (ALB)
- Routes all external traffic via **HTTPS**.  
- Configured with **HTTP → HTTPS redirect**.  
  - Example: `http://app.sulig.click` → redirected to **HTTPS**.  
- Integrated with **ACM-issued certificate** for TLS termination.  
---

### Domain & Certificates
- **Route 53** manages DNS.  
- **ACM** issues a **wildcard SSL/TLS certificate (`*.sulig.click`)**, allowing flexibility for variety of subdomains.  
- ALB uses ACM certificate to serve **HTTPS traffic**.  

---

### ECS & Compute
- **ECS Cluster** runs on **Fargate** (serverless containers).  
- **ECS Service** manages scaling and ensures availability.  
- **ECS Task Definition** defines:  
  - App container  
  - Environment variables  
  - Resources  
- **CloudWatch Logs** capture application and container logs.  

---

### IAM
- **ECS Task Execution Role** with least-privilege permissions.  
- Scoped only to required services (e.g., image pulling, logging).  

---

### CI/CD (GitHub Actions)
- Workflows automate:  
  - Build  
  - Plan  
  - Apply  
  - Destroy  

**Pipeline Flow:**  
1. Docker image built and pushed to **ECR**.  
2. **Terraform Bootstrap** (manual) → sets up S3 + DynamoDB.  
3. **Terraform Plan** runs automatically.  
4. Plan reviewed → **Terraform Apply** requires manual approval.  
5. **Terraform Destroy** can be run manually to tear down infra.  

---

## Technologies Used

| Category            | Tools/Services |
|----------------------|----------------|
| Cloud               | AWS ECS (Fargate), ALB, VPC, NAT Gateway |
| Networking & DNS    | Route 53, ACM (TLS/SSL) |
| IaC                 | Terraform (modular structure) |
| CI/CD               | GitHub Actions |
| Containerisation    | Docker |
| Monitoring          | Amazon CloudWatch |
| Security            | IAM Roles & Security Groups |

---

## Project Structure

