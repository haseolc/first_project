provider "aws" {
  region = "ap-northeast-2"
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

# 기존 EC2 데이터 조회
data "aws_instance" "ec2-7th-room" {
  filter {
    name   = "tag:Name"
    values = ["ec2-7th-room"] # main 브랜치에서 정한 이름
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# 기존 인프라 자원 재사용
data "aws_vpc" "default" { default = true }
data "aws_security_group" "rds_sg" { name = "rds_sg_7th_room" }
data "aws_db_subnet_group" "rds_subnet_group" { name = "rds-subnet-group" }

# 최신 수동 스냅샷 조회
#data "aws_db_snapshot" "latest_manual" {
#  db_instance_identifier = "rds-7th-room" # 원본 DB 식별자
#  most_recent            = true
#  snapshot_type          = "manual" # 수동 스냅샷 기준
#}

# DR용 RDS 스냅샷 복구
resource "aws_db_instance" "db_7th_room_dr" {
  identifier             = "rds-7th-room-dr"
  # 데이터, DB 구조, 사용자, 비밀번호, 엔진/버전 모두 스냅샷 기준으로 복원
  snapshot_identifier    = var.snapshot_id
  instance_class         = "db.t3.micro" # 인스턴스 클래스는 스냅샷에 저장되지 않음

  db_subnet_group_name   = data.aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [data.aws_security_group.rds_sg.id]

  # 스냅샷에서 자동으로 가져오지 않는 부분
  multi_az                = false
  availability_zone       = "ap-northeast-2a"
  publicly_accessible     = false
  backup_window           = "18:00-19:00" # KST 기준 03:00-04:00
  skip_final_snapshot     = false
  backup_retention_period = 1
}

# 결과 출력 (GitHub Actions 전달용)
output "ec2_public_ip" {
  value = data.aws_instance.ec2-7th-room.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.db_7th_room_dr.address
}
