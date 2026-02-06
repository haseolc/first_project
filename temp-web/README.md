## 작성 방법
+) 구조
```bash
admin-test/
├─ api/
│   ├─ app.py
│   ├─ Dockerfile
│   └─ templates/
│       ├─ index.html      # 로그인 화면
│       └─ dashboard.html  # 로그인 후 화면
├─ db/
│   └─ init.sql            # 관리자 계정
└─ docker-compose.yml
```
docker-compose 설치 전제 하에 진행됩니다.

(touch한 파일들은 ```vi``` 편집기 이용해서 여기 GitHub에 있는 파일 복붙하시면 됩니다.)
```bash
mkdir admin-test && cd admin-test

touch docker-compose.yml

mkdir api db

cd api
touch app.py Dockerfile

mkdir templates
cd templates
touch index.html dashboard.html

cd ~/admin-test/db
touch init.sql

sudo docker compose up -d --build
```
+) 컨테이너 목록: ```sudo docker ps -a```
```bash
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                         NAMES
814c14d28a71   admin-test-api   "python app.py"          27 minutes ago   Up 27 minutes   0.0.0.0:5000->5000/tcp, [::]:5000->5000/tcp   admin-test-api-1
c29b651e6c0e   mysql:8.0        "docker-entrypoint.s…"   27 minutes ago   Up 27 minutes   3306/tcp, 33060/tcp                           admin-test-db-1
```

## 0. 접속
http://localhost:5000

## 1. 로그인 화면
<img alt="image" src="https://github.com/user-attachments/assets/0586afcc-e88a-4124-9731-020d16c01d6d" width="700"/>

## 2-1. 로그인 성공 시
<img alt="image" src="https://github.com/user-attachments/assets/6f186228-c970-44b2-b6ca-3393bc8564ad" width="700"/>

## 2-2. 로그인 실패 시
<img alt="image" src="https://github.com/user-attachments/assets/71b496fb-2dbf-4e34-9e19-a3ec5e38aef3" width="700"/>
