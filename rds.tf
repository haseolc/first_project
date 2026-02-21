provider "aws" {
  region = "ap-northeast-2"
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

# 1. 기존 EC2 데이터 조회 (태그 기반 권장 - ID가 바뀌어도 대응 가능)
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

# 2. 기존 인프라 자원 재사용
data "aws_vpc" "default" { default = true }
data "aws_security_group" "rds_sg" { name = "rds_sg_7th_room" }
data "aws_db_subnet_group" "rds_subnet_group" { name = "rds-subnet-group" }

# 3. 최신 스냅샷 조회 (최근 생성된 수동 스냅샷 기준)
data "aws_db_snapshot" "latest_manual" {
  db_instance_identifier = "rds-7th-room" # 원본 DB 식별자
  most_recent            = true
  snapshot_type          = "manual"      # 직접 생성한 스냅샷 기준
}

# 4. DR용 RDS 스냅샷 복구
resource "aws_db_instance" "db_7th_room_dr" {
  identifier             = "rds-7th-room-dr"
  snapshot_identifier    = data.aws_db_snapshot.latest_manual.id
  instance_class         = "db.t3.micro"
  
  # 스냅샷 복구 시 엔진, 버전, DB이름 등은 스냅샷 설정을 그대로 따릅니다.
  # 비밀번호는 복구된 인스턴스에 새로 설정할 수 있습니다.
  password               = var.db_password

  db_subnet_group_name   = data.aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [data.aws_security_group.rds_sg.id]

  publicly_accessible     = false
  skip_final_snapshot     = true # 실습용이므로 종료 시 스냅샷 생략
}

# 5. 결과 출력 (GitHub Actions 전달용)
output "ec2_public_ip" {
  value = data.aws_instance.ec2-7th-room.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.db_7th_room_dr.address
}