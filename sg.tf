provider "aws" {
  region = "ap-northeast-2"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ssh_sg" {
  name = "ssh_sg_7th_room"
  vpc_id = data.aws_vpc.default.id
  description = "관리자 SSH 접속"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-sg-7th-room"
  }
}

resource "aws_security_group" "web_sg" {
  name = "web_sg_7th_room"
  vpc_id = data.aws_vpc.default.id
  description = "웹 서비스 및 내부 통신"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow external HTTP for WAF testing"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow external HTTPS for WAF testing"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg-7th-room"
  }
}

output "ssh_sg_7th_room" {
  value = aws_security_group.ssh_sg.id
}

output "web_sg_7th_room" {
  value = aws_security_group.web_sg.id
}
