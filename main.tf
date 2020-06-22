# terraform plan 시 argument로 전달 받음

variable "aws_access_key"{ 
	type=string
	description="aws access key"
}

variable "aws_secret_key"{
	type=string
	description="aws secret key"
}

variable "aws_region"{
	type=string
	description="aws region"
}

provider "aws" {
	access_key = var.aws_access_key
	secret_key = var.aws_secret_key
	region = var.aws_region 
}
