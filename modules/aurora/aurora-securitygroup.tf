resource "aws_security_group" "sg-aurora" {
  name   = "aws-sg-${var.stage}-${var.servicename}-aurora-${var.dbname}"
  vpc_id = var.network_vpc_id

  ingress {
    description = ""
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = var.sg_allow_ingress_list_aurora
  }

  ingress {
    description = ""
    from_port       = 3306
    to_port         = 3306
    protocol        = "TCP"
    security_groups = var.sg_allow_ingress_sg_list_aurora
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(tomap({
         Name =  "aws-sg-${var.stage}-${var.servicename}-aurora-${var.dbname}"}),
        var.tags)
}
