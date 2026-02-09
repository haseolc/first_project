# 아직 수정 중 ~

resource "aws_db_instance" "mydb" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "mydb" # DB 식별자
  username             = var.db_username # 마스터 이름
  password             = var.db_password # 마스터 암호
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true # 삭제 시 마지막 스냅샷 자동 생성 (실습용이라 X)
  backup_retention_period = 7
  publicly_accessible  = false # EC2 내부에서만 접근 가능

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_subnet.id
  tags = {
    Name = "mydb"
  }
}

resource "aws_db_subnet_group" "my_subnet" {
  name       = "mydb-subnet"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "mydb-subnet"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.mydb.address
  description = "RDS 엔드포인트"
}
