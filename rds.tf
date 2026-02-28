provider "aws" {
  region = "ap-northeast-2"
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true # 민감 정보
}

# 기존 VPC 조회
data "aws_vpc" "default" {
  default = true
}

# 외부 보안 그룹 조회
data "aws_security_group" "ec2_sg" {
  name = "ec2_sg_7th_room"
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
  name        = "rds_sg_7th_room"
  description = "Allow inbound traffic from team SGs"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.ssh_ec2.id]
  }

  tags = {
    Name = "rds-sg-7th-room"
  }
}

# RDS 서브넷 그룹 생성
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

# 프라이빗 라우팅 테이블 생성
resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "rds-private-rt"
  }
}

# 프라이빗 서브넷 라우팅 연결
resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b_assoc" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}

# RDS 인스턴스 설정 (프리티어 & 비용 방어 최적화)
resource "aws_db_instance" "db_7th_room" {
  identifier             = "rds-7th-room"
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

  # 비용 방어
  multi_az                = false
  availability_zone       = "ap-northeast-2a"
  publicly_accessible     = false
  backup_window           = "18:00-19:00"  # KST 기준 03:00-04:00
  skip_final_snapshot     = false
  backup_retention_period = 1
}

output "rds_endpoint" {
  value = aws_db_instance.db_7th_room.address
}
