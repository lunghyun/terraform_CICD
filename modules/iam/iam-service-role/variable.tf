#variable "role_name" {
#  type = map(object({
#    role_name = string
#    assume_role_policy = json
#    managed_policy = list
#  }))
#}

variable "stage" {
 type = string
}
variable "servicename" {
 type = string
}

variable "tags" {
  type = map(string)
}