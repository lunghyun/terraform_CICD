# vpc/subnet관련 소스
# public subnet az1, 2
# service subnet az1, 2
# db subnet az1, 2
# igw
# nat
# routetable pub,pri
# routetable association

resource "aws_vpc" "aws-vpc" {
  cidr_block           = var.vpc_ip_range
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(tomap({
         Name = "aws-vpc-${var.stage}-${var.servicename}"}), 
        var.tags)
}


#subnet 

resource "aws_subnet" "public-az1" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_public_az1
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 0)
  tags = merge(tomap({
         Name = "aws-subnet-${var.stage}-${var.servicename}-pub-az1"}), 
        var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}
resource "aws_subnet" "public-az2" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_public_az2
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 1)
  tags = merge(tomap({
         Name = "aws-subnet-${var.stage}-${var.servicename}-pub-az2"}), 
        var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

resource "aws_subnet" "service-az1" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_service_az1
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 0)
  tags = merge(tomap({
         Name = "aws-subnet-${var.stage}-${var.servicename}-svc-az1"}), 
        var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}
resource "aws_subnet" "service-az2" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_service_az2
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 1)
  tags = merge(tomap({
         Name = "aws-subnet-${var.stage}-${var.servicename}-svc-az2"}), 
        var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

resource "aws_subnet" "db-az1" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_db_az1
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 0)
  tags = merge(tomap({
         Name = "aws-subnet-${var.stage}-${var.servicename}-db-az1"}), 
        var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

resource "aws_subnet" "db-az2" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_db_az2
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 1)
  tags = merge(tomap({
         Name = "aws-subnet-${var.stage}-${var.servicename}-db-az2"}), 
        var.tags)
  depends_on = [
    aws_vpc.aws-vpc
  ]
}

# # RDS Subnet Group 
# # Fowler - Merge이후 주석 삭제
# resource "aws_db_subnet_group" "db-subnet-group-gitlab" {
#   name                    = "aws-db-subnet-group-gitlab"
#   subnet_ids              = [aws_subnet.db-az1.id, aws_subnet.db-az2.id]
#   tags                    = merge(tomap({
#                             Name = "aws-db-subnet-group-gitlab"}), 
#                             var.tags)
# }

# # redis Subnet Group 
# # Fowler - Merge이후 주석 삭제
# resource "aws_elasticache_subnet_group" "redis-subnet-group-gitlab" {
#   name                    = "aws-redis-subnet-group-gitlab"
#   subnet_ids              = [aws_subnet.db-az1.id, aws_subnet.db-az2.id]
#   tags                    = merge(tomap({
#                             Name = "aws-redis-subnet-group-gitlab"}), 
#                             var.tags)
# }

# igw
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = merge(tomap({
         Name = "aws-igw-${var.stage}-${var.servicename}"}), 
        var.tags)
}

# EIP for NAT
resource "aws_eip" "nat-eip" {
  vpc = "true"
  depends_on                = [aws_internet_gateway.vpc-igw]
  tags = merge(tomap({
         Name = "aws-eip-${var.stage}-${var.servicename}-nat"}), 
        var.tags)
}

# NAT
resource "aws_nat_gateway" "vpc-nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-az1.id
  depends_on = [aws_internet_gateway.vpc-igw, 
                aws_eip.nat-eip]
  tags = merge(tomap({
         Name = "aws-nat-${var.stage}-${var.servicename}"}), 
        var.tags)    
}


#routetable
resource "aws_route_table" "aws-rt-pub" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = merge(tomap({
         Name = "aws-rt-${var.stage}-${var.servicename}-pub"}), 
        var.tags)
}

#resource "aws_route" "route-to-ext-data" {
#  for_each = var.ext_vpc_route
#
#  route_table_id         = aws_route_table.aws-rt-pub.id
#  destination_cidr_block = lookup(each.value, "destination_cidr", null)
#  transit_gateway_id     = aws_ec2_transit_gateway.tgw[0].id
#  lifecycle {
#    create_before_destroy = true
#  }
#}

# resource "aws_route" "route-to-dev-data" {
#   for_each = var.ext_vpc_route.moga-dev

#   route_table_id         = aws_route_table.aws-rt-pub.id
#   destination_cidr_block = each.value
#   transit_gateway_id     = aws_ec2_transit_gateway.tgw[0].id
#   lifecycle {
#     create_before_destroy = true
#   }
# }

## 4.29일 오픈이후 삭제필요 (보안심의에 따름)
# resource "aws_route" "route-to-stg-data" {
#   for_each = var.ext_vpc_route.moga-stg

#   route_table_id         = aws_route_table.aws-rt-pub.id
#   destination_cidr_block = each.value
#   transit_gateway_id     = aws_ec2_transit_gateway.tgw[0].id
#   lifecycle {
#     create_before_destroy = true
#   }
# }
resource "aws_route" "route-to-igw" {
  route_table_id         = aws_route_table.aws-rt-pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.vpc-igw.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "aws-rt-pri" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = merge(tomap({
         Name = "aws-rt-${var.stage}-${var.servicename}-pri"}), 
        var.tags)
}

resource "aws_route" "route-to-nat" {
  route_table_id         = aws_route_table.aws-rt-pri.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.vpc-nat.id
}

#routetable association
resource "aws_route_table_association" "public-az1" {
 subnet_id      = aws_subnet.public-az1.id
 route_table_id = aws_route_table.aws-rt-pub.id
}
resource "aws_route_table_association" "public-az2" {
 subnet_id      = aws_subnet.public-az2.id
 route_table_id = aws_route_table.aws-rt-pub.id
}
resource "aws_route_table_association" "service-az1" {
 subnet_id      = aws_subnet.service-az1.id
 route_table_id = aws_route_table.aws-rt-pri.id
}
resource "aws_route_table_association" "service-az2" {
 subnet_id      = aws_subnet.service-az2.id
 route_table_id = aws_route_table.aws-rt-pri.id
}
resource "aws_route_table_association" "db-az1" {
 subnet_id      = aws_subnet.db-az1.id
 route_table_id = aws_route_table.aws-rt-pri.id
}
resource "aws_route_table_association" "db-az2" {
 subnet_id      = aws_subnet.db-az2.id
 route_table_id = aws_route_table.aws-rt-pri.id
}

