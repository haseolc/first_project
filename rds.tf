provider "aws" {
  region = "ap-northeast-2"
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

# 기존 EC2 데이터 조회 (퍼블릭 IP 조회용)
data "aws_instance" "room7" {
  filter {
    name   = "tag:Name"
    values = ["ec2-7th-room"]
  }
}

# 기존 VPC/SG/서브넷 재사용
data "aws_vpc" "default" { default = true }
data "aws_security_group" "rds_sg" { name = "rds_sg_7th_room" }
data "aws_db_subnet_group" "rds_subnet_group" { name = "rds-subnet-group" }

# 최신 스냅샷 조회
data "aws_db_snapshot" "latest_automated" {
  db_instance_identifier = "rds-7th-room"
  most_recent            = true
  snapshot_type          = "manual" # automated(자동 스냅샷) or manual(수동 스냅샷)
}

# DR용 RDS 스냅샷 복구
resource "aws_db_instance" "db_7th_room_dr" {
  identifier             = "rds-7th-room-dr"
  snapshot_identifier    = data.aws_db_snapshot.latest_automated.id
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "admin_db"
  username               = "admin"
  password               = var.db_password

  db_subnet_group_name   = data.aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [data.aws_security_group.rds_sg.id]

  multi_az                = false
  availability_zone       = "ap-northeast-2a"
  publicly_accessible     = false
  backup_window           = "18:00-19:00"
  skip_final_snapshot     = false
  backup_retention_period = 1
}

output "ec2_public_ip" {
  value = data.aws_instance.room7.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.db_7th_room_dr.address
}
