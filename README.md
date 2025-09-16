# E-Commerce Capstone (Gopi) — AWS DevOps (ap-south-1)

This project deploys a full e-commerce web app on AWS:

- **Frontend**: React → S3 + CloudFront
- **Backend**: Node.js/Express → ECS Fargate behind ALB
- **DB**: RDS MySQL (schema + seed auto-run by backend at first start)
- **Auth**: Cognito (User Pool)
- **CI/CD**: CodePipeline + CodeBuild (+ ECR) — single pipeline for both apps
- **Region**: `ap-south-1`

> NOTE: CloudFront uses the default `*.cloudfront.net` cert (no custom domain required).

## Quick Start (AWS CloudShell)

1) Configure AWS (only once per CloudShell session):

```bash
aws configure
# set region: ap-south-1
```

2) Upload this repo to **GitHub** (single repo). Keep structure as-is.

3) In CloudShell, run Terraform:
```bash
cd infrastructure/terraform
terraform init
terraform apply -auto-approve
```

4) **Authorize GitHub connection** (one-time):
- Open AWS console → Developer Tools → *Connections* (CodeStar Connections) → find connection named `github-gopi-capstone` → *Update/Authorize* with your GitHub account.
- Re-run `terraform apply` if prompted, then release change in CodePipeline (or push a new commit).

5) On first pipeline run:
- **Frontend** will build & deploy to S3. CloudFront will be invalidated.
- **Backend** Docker image will build, push to ECR, and ECS will deploy.
- Backend bootstraps **RDS schema + seed** automatically (idempotent).

6) Output URLs:
- **Frontend**: CloudFront domain (see Terraform outputs)
- **Backend ALB**: ALB DNS (see Terraform outputs)
- **Cognito**: User pool id/ARN (see outputs)

## Screenshots to Capture (for Capstone Report)
- Terraform `apply` plan and success
- CodePipeline stages (Source/Build/Deploy) green
- ECR repo with image
- ECS service running tasks
- ALB target group healthy
- CloudFront Distribution (Status: Deployed) + default domain
- Frontend app showing products with images
- Backend `/health` returns OK

## Cleanup
```bash
cd infrastructure/terraform
terraform destroy -auto-approve
```

---

### Security Notes
- RDS is **NOT** public. Backend seeds DB from inside the VPC on first boot.
- Secrets are in **AWS Secrets Manager**; ECS injects creds as env vars.
