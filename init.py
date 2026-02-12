import pymysql

conn = pymysql.connect(
    host="my-free-tier-db.cno0iam0a9lb.ap-northeast-2.rds.amazonaws.com",
    user="admin",
    password="admin1234!",
    charset='utf8mb4'
)

try:
    with conn.cursor() as cur:
        # DB 생성 및 선택
        cur.execute("CREATE DATABASE IF NOT EXISTS admin_db;")
        cur.execute("USE admin_db;")
        # 테이블 생성
        cur.execute("DROP TABLE IF EXISTS admins;")
        cur.execute("""
            CREATE TABLE admins (
                admin_id VARCHAR(50) PRIMARY KEY,
                admin_pw VARCHAR(255) NOT NULL
            );
        """)
        # 데이터 삽입 (하나씩 넣기보다 여러 개를 한 번에 넣는 게 효율적입니다)
        sql = "INSERT INTO admins (admin_id, admin_pw) VALUES (%s, SHA2(%s, 256))"
        admin_data = [
            ('admin', 'ad123@'),
            ('master', 'ma555#'),
            ('leader', 'ldr445!'),
            ('security', 'secu369@'),
            ('db_admin', 'dadm@511'),
            ('k3s_manager', 'km2253@'),
            ('infra_manager', 'ifm1246!'),
            ('db_manager', '24maks5'),
            ('infra_admin', 'aozk311@'),
            ('k3s_admin', 'rkskekfk216')
        ]
        cur.executemany(sql, admin_data) # 여러 데이터를 효율적으로 삽입
        conn.commit()
        print(" 관리자 계정 생성 완료!")

finally:
    conn.close()
