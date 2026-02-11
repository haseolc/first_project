from flask import Flask, request, render_template, redirect
import mysql.connector
import os
import hashlib

app = Flask(__name__)

# 그라파나 포트 설정
GRAFANA_PORT = "30000"

def get_db_connection():
    return mysql.connector.connect(
        host=os.environ.get("DB_HOST", "terraform-20260210194948525200000001.cl0aokksg3rp.ap-northeast-2.rds.amazonaws.com"), # <---------- RDS 엔드포인트 
        user=os.environ.get("DB_USER", "admin"),
        # password=os.environ.get("DB_PASSWORD", "admin1234!"),
        password = os.environ.get("DB_PASSWORD"), # k3s secret 참조
        database=os.environ.get("DB_NAME", "admin_db")
    )

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/login", methods=["POST"])
def login():
    admin_id = request.form.get("admin_id")
    admin_pw = request.form.get("password")

    # 접속한 서버의 IP를 자동으로 가져오기
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
        # return render_template("dashboard.html", admin_id=admin_id)
        return redirect(target_url)
        #현재는 target_url로 리다이렉트 = 그라파나 홈으로 이동
        #대시보드로 바로 이동하려면 dashboard_url로 리다이렉트
    else:
        return "<h1>로그인 실패</h1><a href='/'>돌아가기</a>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
