output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "frontend_bucket" {
  value = aws_s3_bucket.frontend.bucket
}

output "assets_bucket" {
  value = aws_s3_bucket.assets_bucket.bucket
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}
