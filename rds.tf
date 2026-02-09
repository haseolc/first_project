# 아직 수정 중 ~

# Provider
provider "aws" {
  region = "ap-northeast-2"
}

# VPC / Subnet (기존 것 참조)
data "aws_vpc" "default" {
  default = true
}

# 기본 VPC의 private subnet들
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["false"]
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name   = "rds-mysql-sg"
  vpc_id = data.aws_vpc.default.id

  # EC2 (sg_7th_room) 에서만 MySQL 접근 허용
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_7th_room.id] # ---------------------------------> 수정 예정
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-mysql-sg"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "mydb_subnet" {
  name       = "mydb-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "mydb-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "mydb" {
  identifier              = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_name                 = "mydb"
  username                = var.db_username
  password                = var.db_password

  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 7

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.mydb_subnet.name

  tags = {
    Name = "mydb"
    Environment = "dev"
  }
}

# Outputs
output "rds_endpoint" {
  description = "RDS endpoint (DB_HOST)"
  value       = aws_db_instance.mydb.address
}

output "rds_port" {
  value = aws_db_instance.mydb.port
}
