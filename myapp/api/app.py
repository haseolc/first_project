from flask import Flask, request, render_template, redirect
import mysql.connector
import os
import hashlib
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_host=1, x_proto=1) # ProxyFix 미들웨어 적용

# DB 연결 예외처리
def get_db_connection():
    try:
        return mysql.connector.connect(
            host=os.environ.get("DB_HOST", "db"),
            user=os.environ.get("DB_USER"),
            password=os.environ.get("DB_PASSWORD"),
            database=os.environ.get("DB_NAME")
        )
    except mysql.connector.Error as err:
        print(f"DB Connection Error: {err}")
        return None

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/login", methods=["POST"])
def login():
    admin_id = request.form.get("admin_id")
    admin_pw = request.form.get("password")

    # 접속한 서버의 IP 자동으로 가져오기
    host_ip = request.host.split(':')[0]
    
    # Proxy 헤더를 사용하여 실제 외부 접속 URL 구성
    # Nginx Ingress Controller는 X-Forwarded-Host와 X-Forwarded-Proto 헤더를 설정합니다.
    forwarded_host = request.headers.get('X-Forwarded-Host')
    forwarded_proto = request.headers.get('X-Forwarded-Proto', 'http') # 기본값은 http

    if forwarded_host:
        base_url = f"{forwarded_proto}://{forwarded_host}"
    else:
        # X-Forwarded-Host 헤더가 없을 경우, Flask의 기본 호스트 URL 사용 (내부 IP일 가능성 높음)
        # 이 경우는 일반적으로 프록시 설정이 잘못되었거나, 직접 접속했을 때 발생합니다.
        base_url = request.host_url.rstrip('/')
     # URL 구성
    target_url = f"{base_url}/grafana/"
    dashboard_url = f"{base_url}/grafana/dashboards" 

    hashed_pw = hashlib.sha256(admin_pw.encode()).hexdigest()
    
    conn = get_db_connection()

    # DB 연결 실패 체크
    if conn is None:
        return "<h1>DB 연결 실패</h1>", 500
        
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
