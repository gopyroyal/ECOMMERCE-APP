# CodeStar Connection (requires manual GitHub authorize step)
resource "aws_codestarconnections_connection" "github" {
  name          = "github-gopi-capstone"
  provider_type = "GitHub"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_name}-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "codepipeline.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.project_name}-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["codebuild:BatchGetBuilds","codebuild:StartBuild"], Resource = "*" },
      { Effect = "Allow", Action = ["iam:PassRole"], Resource = "*" },
      { Effect = "Allow", Action = ["ecr:*","ecs:*","s3:*","cloudfront:*","codestar-connections:UseConnection"], Resource = "*" }
    ]
  })
}

resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_name}-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "codebuild.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.project_name}-codebuild-policy"
  role = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["logs:*","s3:*","ecr:*","ecs:*","cloudfront:*","sts:GetCallerIdentity"], Resource = "*" }
    ]
  })
}

resource "aws_s3_bucket" "artifacts" {
  bucket        = "${var.project_name}-artifacts-${random_id.rand.hex}"
  force_destroy = true
}

resource "aws_codebuild_project" "build" {
  name          = "${var.project_name}-build"
  service_role  = aws_iam_role.codebuild_role.arn
  artifacts { type = "CODEPIPELINE" }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    environment_variable {
      name  = "VITE_API_URL"
      value = "http://${aws_lb.alb.dns_name}"
    }
    environment_variable {
      name  = "CLOUDFRONT_DISTRIBUTION_ID"
      value = aws_cloudfront_distribution.frontend.id
    }
    environment_variable {
      name  = "ECR_REPO_NAME"
      value = aws_ecr_repository.backend.name
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name  = "FRONTEND_BUCKET_NAME"
      value = aws_s3_bucket.frontend.bucket
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/../../buildspec.yml")
  }
  logs_config {
    cloudwatch_logs { group_name = "/codebuild/${var.project_name}" }
  }
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.project_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      name             = "GitHub"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "USER/REPO" # TODO: replace after creating GitHub repo
        BranchName       = "main"
      }
    }
  }
  stage {
    name = "Build"
    action {
      name             = "CodeBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      name            = "ECS-Rolling"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"
      configuration = {
        ClusterName = aws_ecs_cluster.main.name
        ServiceName = aws_ecs_service.backend.name
        FileName    = "im_a_placeholder.txt"
      }
    }
  }
  depends_on = [aws_codebuild_project.build]
}
