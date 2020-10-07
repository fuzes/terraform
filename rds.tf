resource "aws_subnet" "my_vpc_db_subnet1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.10.20.0/24"
    availability_zone = "ap-northeast-2a"
    tags = {
        Name = "db-private-1"
    }
}

resource "aws_subnet" "my_vpc_db_subnet2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.10.21.0/24"
    availability_zone = "ap-northeast-2c"
    tags = {
        Name = "db-private-2"
    }
}

resource "aws_db_subnet_group" "db_subnet_group" {
	name = "default db subnet"
	subnet_ids = [aws_subnet.my_vpc_db_subnet1.id, aws_subnet.my_vpc_db_subnet2.id]
}

resource "aws_security_group" "db_security_group" {
	name = "db security group"
	vpc_id = aws_vpc.my_vpc.id
}

resource "aws_security_group_rule" "allow_3306" {
	type = "ingress"
	from_port = 3306
	to_port = 3306
	protocol = "tcp"
	security_group_id = aws_security_group.db_security_group.id
	source_security_group_id = aws_security_group.bastion_security.id
}

resource "aws_db_instance" "my_rds" {
	engine = "mysql"
	allocated_storage = 20
	engine_version = "5.6.35"
	instance_class = "db.t2.micro"
	name = var.database_name
	username = var.database_user
	password = var.database_password
	db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
	vpc_security_group_ids = [aws_security_group.db_security_group.id]
	skip_final_snapshot	= true
}
