# 3-5. 배포 매니페스트 (infra.yml)

`infra.yml`은 **Kubernetes에 실제로 배포되는 리소스를 정의한 파일**이다.

이 파일이 적용되면서 애플리케이션이 실행되고, 외부 접근 경로가 생성된다.

구성은 다음 4가지 리소스로 이루어진다.

- Secret
- Deployment
- Service
- Ingress

---

# 1️⃣ Secret 생성

```yaml
kind:Secretname:db-secret
```

포함 내용:

- `DB_PASSWORD` (Base64 인코딩)

의미는 다음과 같다.

- DB 비밀번호를 코드에 직접 노출하지 않기 위함이다.
- Deployment에서 환경변수로 참조된다.

주의 사항:

- Base64는 암호화가 아니라 인코딩이다.
- 운영 환경에서는 외부 Secret 관리 시스템 사용이 바람직하다.

---

# 2️⃣ Deployment 생성

```yaml
kind:Deploymentname:myapi
```

주요 설정:

- replicas: 1
- image: `${DOCKER_USERNAME}/myapi:latest`
- imagePullPolicy: Always

환경 변수 설정:

- `DB_HOST` → `__RDS_ENDPOINT__` (Actions에서 치환)
- `DB_USER` → admin
- `DB_PASSWORD` → Secret 참조
- `DB_NAME` → admin_db

의미는 다음과 같다.

- Docker Hub에 업로드된 최신 이미지를 항상 가져온다.
- DB 주소는 Terraform 결과를 자동 주입한다.
- DB 비밀번호는 Secret에서 가져온다.

이 Deployment가 실행되면:

- Pod가 생성된다.
- Flask API 컨테이너가 실행된다.

---

# 3️⃣ Service 생성

```yaml
kind:Servicetype:ClusterIP
```

설정:

- 포트 80 → 컨테이너 포트 5000

의미는 다음과 같다.

- 클러스터 내부에서 `myapi`라는 이름으로 접근 가능하다.
- 외부에서는 직접 접근할 수 없다.
- Ingress를 통해서만 외부에 노출된다.

---

# 4️⃣ Ingress 생성 (WAF 적용 지점)

```yaml
kind:Ingressname:myapi-waf-ingress
```

주요 설정:

- ingressClassName: nginx
- ModSecurity 활성화
- TLS Secret 사용

의미는 다음과 같다.

- 외부 트래픽은 먼저 ingress-nginx를 통과한다.
- ModSecurity + OWASP CRS가 요청을 검사한다.
- 정상 요청만 API로 전달된다.

구조는 다음과 같다.

```
사용자 →Ingress(WAF) → Service →Pod(API)
```

---

# 5️⃣ RDS Endpoint 동적 치환 구조

`DB_HOST` 값은 고정되어 있지 않다.

배포 전 단계에서:

```
__RDS_ENDPOINT__ → 실제 RDS endpoint
```

로 치환된다.

이 구조의 장점은 다음과 같다.

- 인프라 변경 시 수동 수정이 필요 없다.
- IP/endpoint가 바뀌어도 자동 반영된다.
- 인프라와 애플리케이션 설정이 자동으로 연결된다.

---

# 매니페스트 전체 흐름 요약

| 리소스 | 역할 |
| --- | --- |
| Secret | DB 비밀번호 저장 |
| Deployment | API 컨테이너 실행 |
| Service | 내부 통신 제공 |
| Ingress | 외부 접근 + WAF 적용 |

---

이 단계가 완료되면

Kubernetes 위에서 애플리케이션이 실행되고, WAF를 통해 외부 접근이 가능해진다.
