#!/usr/bin/env bash
set -euo pipefail

REGION="ap-south-1"

echo "==> Ensuring Terraform deployment in $REGION"
cd infrastructure/terraform
terraform init
terraform apply -auto-approve

echo "==> Reminder: Authorize GitHub connection (CodeStar Connections) in AWS Console, then update pipeline source to your repo if needed."
echo "==> After authorization, push a commit to GitHub to trigger CodePipeline."
