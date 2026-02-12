data "aws_db_instance" "endpoint" {
  db_instance_identifier = "rds-7th-room"
}

output "endpoint" {
  value = data.aws_db_instance.endpoint.endpoint
}
