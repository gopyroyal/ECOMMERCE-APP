# Upload asset placeholders to the assets bucket
resource "aws_s3_object" "asset_objs" {
  for_each = fileset("${path.module}/../../assets", "*.png")
  bucket   = aws_s3_bucket.assets_bucket.id
  key      = each.value
  source   = "${path.module}/../../assets/${each.value}"
  etag     = filemd5("${path.module}/../../assets/${each.value}")
  content_type = "image/png"
}
