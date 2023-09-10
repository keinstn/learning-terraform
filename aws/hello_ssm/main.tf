# EC2
resource "aws_instance" "hello" {
  ami                  = "ami-0a21e01face015dd9"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ssm_ec2_instance_profile.name
  security_groups      = ["default", aws_security_group.ssh.name]

  tags = {
    Name = "hello"
  }
}

# IAM
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_ec2_instance_profile" {
  name = "SSM-EC2-Instance-Profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# Security Group
resource "aws_security_group" "ssh" {
  name = "ssh"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.ssh.id
}

provider "aws" {
  region = "ap-northeast-1"
}
