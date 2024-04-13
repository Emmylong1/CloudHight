variable "AWS_REGION" {
  default = "us-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cidr_blocks_public_subnet" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cidr_blocks_private_subnet" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "instance_type" {
  type        = string
  description = "EC2 instance type for launch template"
  default     = "t3a.micro"
}

