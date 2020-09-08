locals {
  subnets = concat([aws_subnet.my_vpc_private_subnet1.id], [aws_subnet.my_vpc_private_subnet2.id])
}

resource "aws_security_group" "frontend_security" {
	vpc_id = aws_vpc.my_vpc.id
	name = "frontend_security"

	ingress {
		from_port = 3000
		to_port = 3000
		protocol = "tcp"
		security_groups = [aws_security_group.frontend_lb_security.id]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = [aws_security_group.bastion_security.id]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "frontend_instance" {
	count = 2
	ami = "ami-027ce4ce0590e3c98"
	instance_type = "t2.micro"
	key_name = aws_key_pair.server.key_name
	subnet_id = element(local.subnets, count.index)
	vpc_security_group_ids = [
		aws_security_group.frontend_security.id
	] 
	root_block_device {
		volume_size = 20
	}
}
