##Comm (all required)
variable "stage"{
  type = string
  default = "dev"
}
variable "servicename"{
  type = string
  default = "jung9546"
}
variable "tags"{
  type = map(string)
  default = {
    "name" = "jung9546-db"
  }
}

##RDS
variable "dbname" { #required
  type=string
  default = "jung9546-db"
}
variable "engine" {
  type=string
  default = "aurora-mysql"
}

variable "engine_version"{
  type= string
  default = "8.0.mysql_aurora.3.01.0"
}
variable "master_username"{
  type = string
  default = "root"
}
variable "backup_retention_period"{
  type = string
  default = 30
}
variable "backup_window"{
  type = string
  default = "18:00-20:00"
}
variable "kms_key_id" { #required
  type = string
}
variable "enabled_cloudwatch_logs_exports" {
  type = list
  default = ["audit", "error", "general", "slowquery"]
}

variable "max_capacity"{
  type = string
  default=16
}
variable "min_capacity"{
  type = string
  default=1
}
variable "max_connections"{
  type = string
  default=16000
}
variable "max_user_connections"{
  type = string
  default=4294967295
}
variable "seconds_util_auto_pause"{
  type = string
  default=10800
}
variable "timeout_action"{
  type = string
  default = "ForceApplyCapacityChange"
}
variable "family"{
  type = string
  default = "aurora-mysql8.0"
}

variable "port"{
  type = string
  default = "3306" #mysql
}

##Network (all required)
variable "az" {
  type = list(any)
}
variable "subnet_ids" { 
  type = list
}

variable "network_vpc_id"{
  type = string
}

variable "sg_allow_ingress_list_aurora"{
  type = list
  default = []
}
variable "sg_allow_ingress_sg_list_aurora"{
  type = list
  default = []
}


##rds instance
variable "rds_instance_count"{
  type = number
  default = 0
}
variable "rds_instance_class"{
  type = string
  default = "db.r6g.large"
}
variable "rds_instance_auto_minor_version_upgrade"{
  type = bool
  default = false
}
variable "rds_instance_publicly_accessible"{
  type = bool
  default = false
}