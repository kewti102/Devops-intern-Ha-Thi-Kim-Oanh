variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "project" {
  description = "Project tag"
  type        = string
  default     = "devops-training"
}

variable "owner" {
  description = "Owner tag"
  type        = string
}


variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
  default     = "day8"
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "my_ip" {
  description = "Your public IP in CIDR format, example: 1.2.3.4/32"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH"
  type        = string
  default     = ""
}
