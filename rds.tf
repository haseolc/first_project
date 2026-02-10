provider "aws" {
  region = "ap-northeast-2"
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  # 보안을 위해 default는 비워두고 GitHub Secrets나 실행 시 입력 권장
  default     = "admin1234!" 
}

# 기존(Default) VPC 정보 조회
data "aws_vpc" "default" {
  default = true
}

# 외부 보안 그룹 2개 정보 조회 (이름으로 ID 찾아오기)
data "aws_security_group" "ssh_sg" {
  name = "ssh_sg_7th_room"
}

data "aws_security_group" "web_sg" {
  name = "web_sg_7th_room"
}

# RDS용 프라이빗 서브넷 2개 생성
resource "aws_subnet" "private_a" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "172.31.64.0/20" 
  availability_zone = "ap-northeast-2a"
  tags = { Name = "rds-private-a" }
}

resource "aws_subnet" "private_b" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "172.31.80.0/20"
  availability_zone = "ap-northeast-2b"
  tags = { Name = "rds-private-b" }
}

# RDS 보안 그룹
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-team"
  description = "Allow inbound traffic from team SGs"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [
      data.aws_security_group.ssh_sg.id,
      data.aws_security_group.web_sg.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS 서브넷 그룹 생성
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

# RDS 인스턴스 설정 (프리티어 & 비용 방어 최적화)
resource "aws_db_instance" "db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = "admin"
  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # 비용 방어
  multi_az                = false
  availability_zone       = "ap-northeast-2a"
  publicly_accessible     = false
  skip_final_snapshot     = true  # 삭제 시 스냅샷 안 만듦 (비용 발생 방지)
  backup_retention_period  = 0     # 자동 백업 비활성화 (스냅샷 저장 공간 0원)
  delete_automated_backups = true  # 삭제 시 백업도 즉시 삭제
}
