resource "aws_rds_cluster" "rds-cluster" {
  cluster_identifier              = lower("aws-rds-cluster-dev-jung9546-aurora-jung9546-db")
  engine                          = var.engine #"aurora-mysql"
  engine_version                  = var.engine_version #"8.mysql_aurora"
  availability_zones              = [element(var.az, 0), element(var.az, 1)]
  db_subnet_group_name            = aws_db_subnet_group.rds-subnet-group.id
  database_name                   = "${var.dbname}db"
  master_username                 = var.master_username
  master_password                 = random_password.rds-password.result
  backup_retention_period         = var.backup_retention_period #30
  preferred_backup_window         = var.backup_window #"18:00-20:00"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds-cluster-parameter-group.name
  vpc_security_group_ids          = [aws_security_group.sg-aurora.id]
  deletion_protection             = true
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_id
  skip_final_snapshot              = true
  port                            = var.port #default 3306
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports

  lifecycle {
    ignore_changes = [availability_zones, engine_version, snapshot_identifier, kms_key_id]
  }
  tags = var.tags
}

resource "aws_rds_cluster_instance" "rds-instance" {
  count                      = var.rds_instance_count
  identifier                  = lower("aws-rds-instance-dev-jung9546-aurora-jung9546db-${count.index}")
  cluster_identifier          = aws_rds_cluster.rds-cluster.id
  engine                     = var.engine
  engine_version             = var.engine_version
  instance_class             = var.rds_instance_class
#  db_parameter_group_name    = aws_db_parameter_group.rds-instance-parameter-group.name
  auto_minor_version_upgrade = var.rds_instance_auto_minor_version_upgrade
  publicly_accessible        = var.rds_instance_publicly_accessible
  # monitoring_role_arn        = var.monitoring_role_arn
  lifecycle {
    ignore_changes = [engine_version,monitoring_interval]
  }
}

resource "random_password" "rds-password" {
  length           = 16
  special          = true
  override_special = "_%"
  #override_special = "/_%@ "
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name_prefix = lower("aws-rds-subnet-group-${var.stage}-${var.servicename}-aurora-${var.dbname}")
  subnet_ids  = var.subnet_ids
}
resource "aws_rds_cluster_parameter_group" "rds-cluster-parameter-group" {
  name=lower("aws-rds-cluster-parameter-group-dev-jung9546-aurora-jung9546-db")
  family      = var.family #"aurora-mysql8"
  description = "RDS cluster parameter group"
  parameter {
    name  = "autocommit"
    value = "0"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_filesystem"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "collation_connection"
    value = "utf8mb4_bin"
    #value = "utf8mb4_unicode_ci"
  }
  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
    #value = "utf8mb4_unicode_ci"
  }
  parameter {
    name         = "lower_case_table_names"
    value        = "1"
    apply_method = "pending-reboot"
  }
  parameter {
    name  = "max_connections"
    value = var.max_connections
  }
  parameter {
    name = "max_user_connections"
    value = var.max_user_connections #default "4294967295"
  }
  parameter {
    name  = "sql_mode"
    value = "PIPES_AS_CONCAT,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
  }
  parameter {
    name  = "time_zone"
    value = "Asia/Seoul"
  }
  parameter {
    name  = "transaction_isolation"
    value = "READ-COMMITTED"
  }
  parameter {
     name         = "connect_timeout" 
     value        = "60"
  }
  parameter {
    name         = "max_connect_errors"
    value        = "100000"
  }
  parameter {
    name         = "max_prepared_stmt_count"
    value        = "1048576"
  }
  parameter {
    name         = "long_query_time"
    value        = 5
  }
  parameter {
    name         = "log_bin_trust_function_creators"
    value        = "1"
  }
  parameter {
    name         = "general_log"
    value        = "0"
  }
  parameter {
    name         = "server_audit_events"
    value        = "QUERY"
  }
  parameter {
    name         = "server_audit_excl_users"
    value        = "rdsadmin"
  }
  parameter {
    name         = "server_audit_logging"
    value        = "1"
  }
  tags = var.tags
 
}


resource "aws_db_parameter_group" "rds-instance-parameter-group" {
  name        = lower("aws-rds-instance-parameter-group-dev-jung9546-aurora-jung9546-db")
  family = var.family #"aurora-postgresql12"
  parameter {
    name  = "autocommit"
    value = "0"
  }
  parameter {
    name  = "max_connections"
    value = var.max_connections
  }
  parameter {
    name = "max_user_connections"
    value = var.max_user_connections #default "4294967295"
  }
  parameter {
    name         = "performance_schema"
    value        = "1"
    apply_method = "pending-reboot"
  }
  parameter {
    name  = "sql_mode"
    value = "PIPES_AS_CONCAT,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
  }
  parameter {
    name  = "transaction_isolation"
    value = "READ-COMMITTED"
  }
  tags = var.tags
 
}
