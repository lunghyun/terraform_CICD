variable "stage" {
    type = string
}

variable "servicename" {
    type = string
}

variable "server_port" {
    type = number
}

variable "my_ip" {
    type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_public_az1_id" {
  type = string
}

variable "subnet_public_az2_id" {
  type = string
}

variable "subnet_public_az1_cidr" {
  type = string
}

variable "subnet_public_az2_cidr" {
  type = string
}

variable "subnet_service_az1_id" {
  type = string
}

variable "subnet_service_az2_id" {
  type = string
}

variable "subnet_service_az1_cidr" {
  type = string
}

variable "subnet_service_az2_cidr" {
  type = string
}

variable "domain_name" {
  type = string
}