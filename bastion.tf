resource "aws_security_group" "bastion_security" {
    vpc_id = aws_vpc.my_vpc.id
    name = "allow_ssh_all"
    description = "Allow ssh port from all"
}

resource "aws_security_group_rule" "allow_ssh_ingress" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.bastion_security.id
    lifecycle { create_before_destroy = true }
}

resource "aws_instance" "bastion" {
	ami = "ami-027ce4ce0590e3c98"
	instance_type = "t2.micro"
	key_name = aws_key_pair.server.key_name
	subnet_id = aws_subnet.my_vpc_public_subnet1.id
	vpc_security_group_ids = [
		aws_security_group.bastion_security.id
	]
	root_block_device {
		volume_size = 20
	}
	tags = {
		Name = "Bastion"
	}	
}
