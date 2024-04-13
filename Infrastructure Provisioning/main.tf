
#Create Launch template 
resource "aws_launch_template" "Cloudhight" {
  name                   = "Cloudhighttemplate"
  description            = "Template to launch EC2 instance"
  image_id               = "ami-0eb199b995e2bc4e3"
  instance_type          = var.instance_type
  key_name = "interview-key"
  vpc_security_group_ids = [aws_security_group.ec2_secgrp.id]
  iam_instance_profile {
    arn = aws_iam_instance_profile.Cloudhigt-Iam-instance.arn
  }
  user_data = filebase64("installdocker.sh")
}

#Create Auto scaling group
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier       = [aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id]
  desired_capacity          = 3
  max_size                  = 3
  min_size                  = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns = [aws_lb_target_group.cloudhight_target_group.arn]
  launch_template {
    id      = aws_launch_template.Cloudhight.id
    version = "$Latest"
  }
}
