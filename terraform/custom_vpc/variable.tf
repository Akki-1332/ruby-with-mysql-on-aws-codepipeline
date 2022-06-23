variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "subnet_cidr" {
  default = ["10.10.1.0/24", "10.10.2.0/24"]
  type = list
}

variable "az" {
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  type = list
}

variable "public_ip" {
  default = ["true", "false"]
  type = list
}
