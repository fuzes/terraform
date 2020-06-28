// public subnet

resource "aws_subnet" "my_vpc_public_subnet1" {
	vpc_id = aws_vpc.my_vpc.id
	cidr_block = "10.10.1.0/24"
	map_public_ip_on_launch = true
	availability_zone = "ap-northeast-2a"
	tags = {
		Name = "public-1"
	}
}

resource "aws_subnet" "my_vpc_public_subnet2" {
	vpc_id = aws_vpc.my_vpc.id
	cidr_block = "10.10.2.0/24"
	map_public_ip_on_launch = true
	availability_zone = "ap-northeast-2c"
	tags = {
		Name = "public-2"
	}
}

// link network acl to public subnet

resource "aws_network_acl" "public_network_acl" {
	vpc_id = aws_vpc.my_vpc.id
	subnet_ids = [
		aws_subnet.my_vpc_public_subnet1.id,
		aws_subnet.my_vpc_public_subnet2.id
	]
	tags = {
		Name = "public-network-acl"
	}
}


// add rule to public network acl

resource "aws_network_acl_rule" "public_acl_igress" {
	network_acl_id = aws_network_acl.public_network_acl.id
	rule_number = 100
	rule_action = "allow"
	egress = false
	protocol = -1 
	cidr_block = "0.0.0.0/0"
	from_port = 0
	to_port = 0 
}


resource "aws_network_acl_rule" "public_acl_engress" {
	network_acl_id = aws_network_acl.public_network_acl.id
	rule_number = 100
	rule_action = "allow"
	egress = true
	protocol = -1 // "tcp"
	cidr_block = "0.0.0.0/0"
	from_port = 0
	to_port = 0
}

// link route table to public subnet

resource "aws_route_table_association" "public_subnet1_association" {
	subnet_id = aws_subnet.my_vpc_public_subnet1.id
	route_table_id = aws_vpc.my_vpc.main_route_table_id
}

resource "aws_route_table_association" "public_subnet2_association" {
	subnet_id = aws_subnet.my_vpc_public_subnet2.id
	route_table_id = aws_vpc.my_vpc.main_route_table_id
}

// create nat gateway

resource "aws_eip" "my_vpc_nat_eip" {
	vpc = true
	depends_on = [aws_internet_gateway.my_vpc_igw]
}

resource "aws_nat_gateway" "my_vpc_nat" {
	allocation_id = aws_eip.my_vpc_nat_eip.id
	subnet_id = aws_subnet.my_vpc_public_subnet1.id
	depends_on = [aws_internet_gateway.my_vpc_igw]
	tags = {
		Name = "my_vpc_nat"
	}
}
