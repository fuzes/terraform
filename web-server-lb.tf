resource "aws_security_group" "frontend_lb_security" {
	vpc_id = aws_vpc.my_vpc.id
	name = "frontend_lb_security"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 433
		to_port = 433
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

resource "aws_lb" "frontend_lb" {
	name = "frontendlb"
	internal = false
	load_balancer_type = "application"
	security_groups = [aws_security_group.frontend_lb_security.id]
	subnets = [aws_subnet.my_vpc_private_subnet1.id, aws_subnet.my_vpc_private_subnet2.id]
}

resource "aws_lb_target_group" "frontend_group" {
	name = "frontendTargetGroup"
	port = 3000
	protocol = "HTTP"
	vpc_id = aws_vpc.my_vpc.id
}

resource "aws_acm_certificate" "frontend_cert" {
	domain_name = "fuzes.io"
	validation_method = "DNS"
}

resource "aws_lb_listener" "frontend_443" {
	load_balancer_arn = aws_lb.frontend_lb.arn
	port = "443"
	protocol = "HTTPS"
	ssl_policy = "ELBSecurityPolicy-2016-08"
	certificate_arn = aws_acm_certificate.frontend_cert.arn

	default_action {
		type = "forward"
		target_group_arn = aws_lb_target_group.frontend_group.arn
	}
}

resource "aws_lb_listener" "frontend_80" {
	load_balancer_arn = aws_lb.frontend_lb.arn
	port = "80"
	protocol = "HTTP"
	
	default_action {
		type = "redirect"
		
		redirect {
			port = "443"
			protocol = "HTTPS"
			status_code = "HTTP_301"
		}
	}
}

