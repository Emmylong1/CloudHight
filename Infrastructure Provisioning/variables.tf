variable "AWS_REGION" {
  default = "us-west-2"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ami" {
  type        = string
  description = "EC2 instance type for public subnet"
  default     = "ami-08116b9957a259459"
}


variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]  # Update with your desired Availability Zones
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
  description = "EC2 instance type for private subnet"
  default     = "t2.micro"
}



variable "jenkins-instance_type" {
  type        = string
  description = "EC2 instance type for private subnet"
  default     = "t3.medium"
}

