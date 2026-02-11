resource "kubernetes_secret" "db_secret" {
  metadata {
    name = "db-secret"
    namespace = "default"
  }

  data = {
    DB_PASSWORD = var.db_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "db_secret" {
  metadata {
    name = "db-secret"
  }

  data = {
    DB_HOST = aws_db_instance.db.address
    DB_USER = aws_db_instance.db.username
    DB_PASSWORD = var.db_password
    DB_NAME = aws_db_instance.db.db_name
  }
}
