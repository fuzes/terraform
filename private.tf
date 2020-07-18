// private subnet

resource "aws_subnet" "my_vpc_private_subnet1" {
	vpc_id = aws_vpc.my_vpc.id
	cidr_block = "10.10.10.0/24"
	availability_zone = "ap-northeast-2a"
	tags = {
		Name = "private-1"
	}
}

resource "aws_subnet" "my_vpc_private_subnet2" {
	vpc_id = aws_vpc.my_vpc.id
	cidr_block = "10.10.11.0/24"
	availability_zone = "ap-northeast-2c"
	tags = {
		Name = "private-2"
	}
}

// link network acl to private subnet

resource "aws_network_acl" "private_network_acl" {
	vpc_id = aws_vpc.my_vpc.id
	subnet_ids = [
		aws_subnet.my_vpc_private_subnet1.id,
		aws_subnet.my_vpc_private_subnet2.id
	]
	tags = {
		Name = "private_netowrk_acl"
	}
}

resource "aws_network_acl_rule" "private_acl_ingress" {
	network_acl_id = aws_network_acl.private_network_acl.id
	rule_number = 100
	rule_action = "allow"
	egress = false
	protocol = -1
	cidr_block = "0.0.0.0/0"
	from_port = 0
	to_port = 0
}

resource "aws_network_acl_rule" "private_acl_egress" {
	network_acl_id = aws_network_acl.private_network_acl.id
	rule_number = 100
	rule_action = "allow"
	egress = true
	protocol = -1
	cidr_block = "0.0.0.0/0"
	from_port = 0
	to_port = 0
}

// create private route table

resource "aws_route_table" "my_vpc_private_route_table" {
	vpc_id = aws_vpc.my_vpc.id
	tags = {
		Name = "private"
	}
}

resource "aws_route_table_association" "private_subnet1_association" {
    subnet_id = aws_subnet.my_vpc_private_subnet1.id
    route_table_id = aws_route_table.my_vpc_private_route_table.id
}

resource "aws_route_table_association" "private_subnet2_association" {
    subnet_id = aws_subnet.my_vpc_private_subnet2.id
    route_table_id = aws_route_table.my_vpc_private_route_table.id
}
