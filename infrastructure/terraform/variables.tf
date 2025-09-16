variable "project_name" {
  type        = string
  default     = "gopi-capstone"
  description = "Project name prefix"
}

variable "region" {
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24"]
}

variable "db_username" {
  type        = string
  default     = "admin"
}

variable "db_password" {
  type        = string
  default     = "StrongPassw0rd!"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
}
