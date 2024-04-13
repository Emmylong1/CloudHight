
#Create instance profile role for EC2 instance
resource "aws_iam_role" "Cloudhigt-Iam-instance-Profile-Role" {
  name = "Cloudhigt-Iam-instance-Profile-Role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "sts:AssumeRole"
        ],
        Principal : {
          Service : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

#Attach S3FullAccess permission EC2 instance role
resource "aws_iam_role_policy_attachment" "s3fullaccessattach" {
  role       = aws_iam_role.Cloudhigt-Iam-instance-Profile-Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#Create EC2 instance profile
resource "aws_iam_instance_profile" "Cloudhigt-Iam-instance" {
  name = "Cloudhigt-Iam-instance"
  role = aws_iam_role.Cloudhigt-Iam-instance-Profile-Role.name
}



resource "aws_iam_role" "asg_role" {
  name = "asg-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "asg_access" {
  name       = "cloudhight-asg-access"
  roles      = [aws_iam_role.asg_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
