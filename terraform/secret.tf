data "aws_db_instance" "rds" {
  db_instance_identifier = "terraform-20260211044941925200000001"
}

variable "db_password" {
  type      = string
  sensitive = true
}

resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = "db-secret"
    namespace = "default"
  }

  data = {
    DB_HOST     = data.aws_db_instance.rds.address
    DB_USER     = data.aws_db_instance.rds.username
    DB_PASSWORD = var.db_password
    DB_NAME     = data.aws_db_instance.rds.db_name
  }

  type = "Opaque"
}
