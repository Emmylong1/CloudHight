# EC2 Instance in the Public Subnet
resource "aws_instance" "jenkins_public" {
  ami                         = var.ami
  instance_type               = var.jenkins-instance_type
  subnet_id                   = aws_subnet.public_subnet_az1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_web.id]
  key_name                    = "Cloudhight"
  tags = {
    Name = "jenkins-server"
  }
}


# EBS Volume for Public EC2 Instance
resource "aws_ebs_volume" "public_instance_volume" {
  availability_zone = aws_instance.Clt_public.availability_zone
  size              = 8
  tags = {
    Name = "Cloudhight-Private-Instance-Volume1"
  }
}

# Attach EBS Volume to Public EC2 Instance
resource "aws_volume_attachment" "ebs_cloud" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.public_instance_volume.id
  instance_id = aws_instance.jenkins_public.id
}