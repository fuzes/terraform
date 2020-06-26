resource "aws_vpc" "my_vpc" {
	cidr_block = "10.10.0.0/16"
	enable_dns_hostnames = true
	enable_dns_support = true
	instance_tenancy = "default"

	tags = {
		Name = "my_vpc"
		Env = "test"
	} 
}

resource "aws_default_route_table" "my_vpc" {
	default_route_table_id = aws_vpc.my_vpc.default_route_table_id
	tags = {
		Name = "default"
	}
}

resource "aws_default_security_group" "my_vpc_default_security_group" {
	vpc_id = aws_vpc.my_vpc.id

	ingress {
		protocol = -1
		self = true
		from_port = 0
		to_port = 0
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = ["0.0.0.0/0"]	
	}
	
	tags = {
		Name = "default"
	}
}

resource "aws_default_network_acl" "my_vpc_default_network_acl" {
	default_network_acl_id = aws_vpc.my_vpc.default_network_acl_id

	ingress {
		protocol = -1
		rule_no = 100
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 0
		to_port = 0
	}

	egress {
		protocol = -1
		rule_no = 100
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 0
		to_port = 0
	}

	tags = {
		Name = "default"
	}
}
