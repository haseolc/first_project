from flask import Flask, request, render_template
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    return mysql.connector.connect(
        host="db",
        user="root",
        password="root_pw",
        database="admin_db"
    )

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/login", methods=["POST"])
def login():
    admin_id = request.form.get("admin_id")
    admin_pw = request.form.get("password")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        "SELECT * FROM admins WHERE admin_id=%s AND admin_pw=%s",
        (admin_id, admin_pw)
    )
    admin = cursor.fetchone()
    cursor.close()
    conn.close()

    if admin:
        return render_template("dashboard.html", admin_id=admin_id)
    else:
        return "<h1>로그인 실패</h1><a href='/'>돌아가기</a>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
