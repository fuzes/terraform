resource "aws_key_pair" "server" {
	key_name = "server"
	public_key = file("~/.ssh/server.pub")
}
