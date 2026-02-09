# 아직 코드 수정 중

resource "aws_db_instance" "mydb" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = false
  backup_retention_period = 7
  publicly_accessible  = false

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
