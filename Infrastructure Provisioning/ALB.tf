
# Create an Application Load Balancer (ALB)
resource "aws_lb" "cloudhight-alb" {
  name               = "cloudhight-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]

  tags = {
    Name = "My ALB"
  }
}

# Create a target group
resource "aws_lb_target_group" "cloudhight_target_group" {
  name     = "cloudhigt-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id

  health_check {
    path                = "/ping"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    Name = "cloudhight Target Group"
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.cloudhight-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloudhight_target_group.arn
  }
}



