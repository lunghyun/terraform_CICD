#Comm TAG
variable "tags" {
  type = map(string)
}
variable "stage" {
  type = string
}
variable "servicename" {
  type = string
}

#VPC
variable "az" {
  type = list(any)
}
variable "vpc_ip_range" {
  type = string
}

variable "subnet_public_az1" {
  type = string
}
variable "subnet_public_az2" {
  type = string
}

variable "subnet_service_az1" {
  type = string
}
variable "subnet_service_az2" {
  type = string
}

variable "subnet_db_az1" {
  type = string
}

variable "subnet_db_az2" {
  type = string
}