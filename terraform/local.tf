resource "local_file" "db_config" {
  filename = "${path.module}/db_config.py" # 파일이 생성될 경로 (현재 테라폼 폴더 기준)
  content  = <<-EOT

# Terraform에 의해 자동 생성된 파일
TF_HOST = "${aws_db_instance.db.address}"
TF_DB   = "${aws_db_instance.db.db_name}"
TF_USER = "${aws_db_instance.db.username}"
  EOT
}
