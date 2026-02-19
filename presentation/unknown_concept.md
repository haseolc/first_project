1️⃣ 가용 영역 (Availability Zone, AZ)
■ 무엇인가

하나의 AWS 리전 안에 존재하는 물리적으로 분리된 데이터센터 묶음이다.

예:

ap-northeast-2 (서울 리전)

ap-northeast-2a

ap-northeast-2b

ap-northeast-2c

■ 왜 필요한가

장애 격리

고가용성 구성

■ 우리 프로젝트에서

Terraform에서 AZ a에 있는 Public Subnet만 조회하여 EC2를 생성한다.

✅ 핵심

가용 영역은 “리전 내부의 물리적 분리 구역”이다.

2️⃣ Inbound / Outbound
■ Inbound

외부 → 내 서버로 들어오는 트래픽

예:

22번 포트 (SSH)

80번 (HTTP)

443번 (HTTPS)

■ Outbound

내 서버 → 외부로 나가는 트래픽

예:

EC2가 인터넷으로 패키지 다운로드

Docker 이미지 pull

■ 우리 프로젝트에서

Security Group 설정에서:

ingress { ... }   # Inbound
egress  { ... }   # Outbound

✅ 핵심

Inbound는 들어오는 것, Outbound는 나가는 것.

3️⃣ NodePort
■ 무엇인가

Kubernetes Service 타입 중 하나.

클러스터 외부에서 노드 IP + 특정 포트로 접근 가능하게 하는 방식.

예:

EC2_IP:30080

■ 왜 쓰는가

LoadBalancer 없이 외부 접근을 허용하기 위해 사용.

■ 우리 프로젝트에서

30080

30443

NodePort를 열어 외부 테스트 가능하도록 설정했다.

✅ 핵심

NodePort는 “EC2_IP:특정포트”로 직접 접속하는 방식.

4️⃣ Root Volume 값들

EC2의 기본 디스크 설정이다.

volume_size = 20
volume_type = "gp3"
iops = 3000
throughput = 125

■ 설명
항목	의미
volume_size	디스크 용량 (GB)
volume_type	디스크 종류 (gp3 = SSD)
iops	초당 입출력 횟수
throughput	초당 전송 속도
delete_on_termination	인스턴스 삭제 시 디스크도 삭제
■ 왜 중요한가

Kubernetes + Docker + Helm은 디스크를 많이 사용한다.

8GB는 부족하다.

그래서 20GB 설정.

✅ 핵심

Root Volume은 EC2의 기본 하드디스크 설정이다.

5️⃣ wget

리눅스에서 파일을 다운로드하는 명령어.

wget https://example.com/file


우리 프로젝트에서 MySQL client 설치할 때 사용했다.

6️⃣ Flask API
■ 무엇인가

Python 기반 웹 프레임워크.

@app.route("/")
def hello():
    return "Hello"

■ 우리 프로젝트에서

Flask API를 Docker로 빌드

Kubernetes에 배포

DB 연결

✅ 핵심

Flask는 Python 웹 서버 프레임워크.

7️⃣ Docker
■ 무엇인가

애플리케이션을 “이미지”로 패키징하는 기술.

■ 과정
Dockerfile → docker build → 이미지 생성 → Docker Hub push

■ 왜 필요한가

서버 환경이 달라도 동일하게 실행 가능

Kubernetes는 컨테이너 기반

✅ 핵심

Docker는 실행 환경을 통째로 포장하는 기술.

8️⃣ ingress-nginx
■ 무엇인가

Kubernetes의 Ingress Controller 구현체.

■ 역할

외부 트래픽을 받아서 내부 서비스로 전달.

인터넷
  ↓
Ingress-Nginx
  ↓
Service
  ↓
Pod

■ 왜 필요한가

Kubernetes는 기본적으로 외부 접근 경로가 없다.

✅ 핵심

ingress-nginx는 쿠버네티스의 “관문”이다.

9️⃣ ModSecurity
■ 무엇인가

웹 방화벽(WAF) 엔진.

HTTP 요청을 분석하여 공격 차단.

■ 예

SQL Injection

XSS

Command Injection

■ 우리 프로젝트에서

Ingress-Nginx에 ModSecurity 활성화.

enable-modsecurity: "true"

✅ 핵심

ModSecurity는 HTTP 요청을 검사하는 방화벽 엔진.

🔟 OWASP CRS
■ 무엇인가

OWASP에서 만든 보안 규칙 세트.

CRS = Core Rule Set

■ 역할

ModSecurity가 사용할 공격 탐지 규칙 모음.

예:

SQL Injection 패턴

XSS 패턴

■ 설정
enable-owasp-modsecurity-crs: "true"

✅ 핵심

OWASP CRS는 WAF의 “공격 탐지 규칙집”이다.

1️⃣1️⃣ TLS Secret
■ 무엇인가

Kubernetes에 저장되는 HTTPS 인증서 정보.

kubectl create secret tls waf-tls-secret ...

■ 왜 필요한가

HTTPS 통신을 위해

Ingress에서 443 포트 사용

■ 구성

tls.crt (인증서)

tls.key (개인키)

✅ 핵심

TLS Secret은 HTTPS를 위한 인증서 저장 객체이다.
