resource "aws_lb_target_group" "quest" {
  name = "quest"
  port = 3000
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = "${aws_vpc.quest_vpc.id}"

  health_check {
    enabled = true
    path = "/"
  }

  depends_on = [aws_alb.quest]
}

resource "aws_alb" "quest" {
  name = "quest"
  internal = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_d.id,
    aws_subnet.public_e.id
  ] 

  security_groups = [
      aws_security_group.http.id,
      aws_security_group.https.id,
      aws_security_group.egress_all.id
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "quest_http" {
  load_balancer_arn = "${aws_alb.quest.arn}"
  port = "80"
  protocol = "HTTP"
  
  default_action {
    target_group_arn = "${aws_lb_target_group.quest.arn}"
    type = "forward"
  }
}

output "alb_url"{
    value = "http://${aws_alb.quest.dns_name}"
}