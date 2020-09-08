resource "aws_lb_target_group_attachment" "web_instance_attach" {
  count = 2
  target_group_arn = aws_lb_target_group.frontend_group.arn
  target_id        = aws_instance.frontend_instance[count.index].id
  port             = 3000 
}
