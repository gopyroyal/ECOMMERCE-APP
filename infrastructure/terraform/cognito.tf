resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-users"
  auto_verified_attributes = ["email"]
  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true
  }
}

resource "aws_cognito_user_pool_client" "web" {
  name         = "${var.project_name}-web-client"
  user_pool_id = aws_cognito_user_pool.main.id
  generate_secret = false
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}
