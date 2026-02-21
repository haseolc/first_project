provider "aws" {
  region = "ap-northeast-2"
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

# 기존 VPC/SG/서브넷 재사용
data "aws_vpc" "default" { default = true }
data "aws_security_group" "rds_sg" { name = "rds_sg_7th_room" }
data "aws_db_subnet_group" "rds_subnet_group" { name = "rds-subnet-group" }

# 최신 자동 스냅샷 조회
data "aws_db_snapshot" "latest_automated" {
  db_instance_identifier = "rds-7th-room"
  most_recent            = true
  snapshot_type          = "automated"
}

# DR용 RDS 스냅샷 복구
resource "aws_db_instance" "db_7th_room_dr" {
  identifier             = "rds-7th-room-dr"
  snapshot_identifier    = data.aws_db_snapshot.latest_automated.id # 스냅샷 복구
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "admin_db"
  username               = "admin"
  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  multi_az                = false
  availability_zone       = "ap-northeast-2a"
  publicly_accessible     = false
  backup_window           = "18:00-19:00"
  skip_final_snapshot     = false
  backup_retention_period = 1
}

output "rds_endpoint" {
  value = aws_db_instance.db_7th_room_dr.address
}
