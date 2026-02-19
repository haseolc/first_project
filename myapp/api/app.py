from flask import Flask, request, render_template, redirect
import mysql.connector
import os
import hashlib

app = Flask(__name__)

# 그라파나 포트 설정
GRAFANA_PORT = "30000"

def get_db_connection():
    return mysql.connector.connect(
        host=os.environ.get("DB_HOST"),
        user=os.environ.get("DB_USER"),
        password = os.environ.get("DB_PASSWORD"),
        database=os.environ.get("DB_NAME")
    )

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/login", methods=["POST"])
def login():
    admin_id = request.form.get("admin_id")
    admin_pw = request.form.get("password")

    # 접속한 서버의 IP 자동으로 가져오기
    host_ip = request.host.split(':')[0]
    target_url = f"http://{host_ip}:{GRAFANA_PORT}"
    dashboard_url = f"{target_url}/dashboards"

    hashed_pw = hashlib.sha256(admin_pw.encode()).hexdigest()
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        "SELECT * FROM admins WHERE admin_id=%s AND admin_pw=%s",
        (admin_id, hashed_pw)
    )
    admin = cursor.fetchone()
    cursor.close()
    conn.close()

    if admin:
        return redirect(dashboard_url) 
    else:
        return "<h1>로그인 실패</h1><a href='/'>돌아가기</a>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
