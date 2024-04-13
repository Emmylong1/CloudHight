# EC2 Instance in the Public Subnet
resource "aws_instance" "jenkins_public" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_az1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_web.id]
  key_name                    = "Cloudhight"
  tags = {
    Name = "jenkins-server"
  }
}