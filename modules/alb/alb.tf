resource "aws_security_group" "webserver_sg" {
    name = "aws-asg-${var.stage}-${var.servicename}"
    vpc_id = var.vpc_id

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        # cidr_blocks = [ var.subnet_service_az1_cidr, var.subnet_service_az2_cidr ]
        security_groups = [ aws_security_group.alb_sg.id ]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # egress는 nat gateway를 통해 외부로 나가기 때문에 모든 트래픽을 허용
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# launch template 생성
resource "aws_launch_template" "webserver_template" {
    image_id = "ami-062cddb9d94dcf95d" # Amazon Linux 2023 AMI
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.webserver_sg.id] # 보안그룹은 webserver_sg로 지정

    user_data = base64encode(<<-EOF
                                #!/bin/bash
                                dnf update -y
                                dnf install -y nginx
                                echo "Hello Mello" > /usr/share/nginx/html/index.html
                                systemctl enable nginx
                                systemctl start nginx
                                EOF
    ) # user_data를 통해 인스턴스 생성시 실행할 스크립트를 작성
}

# autoscaling group 생성
resource "aws_autoscaling_group" "webserver_asg" {
    # *** 다시 확인 ***
    vpc_zone_identifier = [ var.subnet_service_az1_id, var.subnet_service_az2_id ]
    health_check_type = "ELB" # 헬스 체크 타입
    target_group_arns = [aws_lb_target_group.target_asg.arn] # 타겟 그룹 아이디
    
    
    min_size = 3
    max_size = 5
    launch_template {
      id = aws_launch_template.webserver_template.id
      version = "$Latest"
    }
    # *** 다시 확인 ***
    depends_on = [ aws_launch_template.webserver_template, aws_lb_target_group.target_asg ]
}

# alb 보안 그룹 생성
resource "aws_security_group" "alb_sg" {
    name = "aws-alb-sg-${var.stage}-${var.servicename}"
    # *** 다시 확인 ***
    vpc_id = var.vpc_id

    # 외부에서 접속 가능이어야 하므로 모든 트래픽을 허용
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = [ var.my_ip ]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# alb 생성
resource "aws_lb" "webserver_alb" {
    name = "aws-alb-${var.stage}-${var.servicename}"

    load_balancer_type = "application"
    # *** 다시 확인 ***
    subnets = [ var.subnet_public_az1_id, var.subnet_public_az2_id ]
    security_groups = [ aws_security_group.alb_sg.id ]
}

# # random id 생성
# resource "random_id" "tg_suffix" {
#   byte_length = 4
# }


# target group 생성
resource "aws_lb_target_group" "target_asg" {
    # name = "tg-${var.stage}-${var.servicename}-${random_id.tg_suffix.hex}"
    name = "tg-${var.stage}-${var.servicename}"
    port = var.server_port
    protocol = "HTTP"
    # *** 다시 확인 ***
    vpc_id = var.vpc_id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 5
    }
}

# listener 생성
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.webserver_alb.arn
    port = var.server_port
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.target_asg.arn
    }
}

resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.webserver_alb.arn
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = data.aws_acm_certificate.cert.arn

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.target_asg.arn
    }
}

# certification arn 생성을 위한 data resource
data "aws_acm_certificate" "cert" {
  domain       = var.domain_name # 도메인 이름
  statuses     = ["ISSUED"] # 발급된 상태인 것만 가져옴
  most_recent  = true # 가장 최근에 발급된 것만 가져옴
}

# listener rule 생성
resource "aws_lb_listener_rule" "webserver_asg_rule" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
      path_pattern {
        values = ["*"]
      }
    }

    action { # 액션 설정
      type = "forward" # 포워드
      target_group_arn = aws_lb_target_group.target_asg.arn # 타겟 그룹 아이디
    }
}