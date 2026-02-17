# 3-9. 전체 실행 결과

Ansible 실행이 완료되면 EC2는 단순 서버가 아니라, **Kubernetes 기반의 서비스 환경**으로 완성된다.

이 단계에서는 최종적으로 무엇이 구성되는지 정리한다.

---

# 1️⃣ 인프라 상태

- EC2 인스턴스 실행 중
- Public IP 할당 완료
- SSH 접속 가능
- k3s 단일 노드 클러스터 구동 중

---

# 2️⃣ Kubernetes 상태

다음 리소스가 생성되어 있다.

- Pod (Flask API)
- Service (ClusterIP)
- Ingress (nginx 클래스)
- Secret (DB 비밀번호)

정상 상태라면:

```
kubectl get nodes
kubectl get pods
kubectl get svc
kubectl get ingress
```

모두 정상 출력된다.

---

# 3️⃣ 애플리케이션 동작 상태

- Docker Hub에서 `myapi:latest` 이미지 pull 완료
- Flask API 컨테이너 실행 중
- RDS endpoint 자동 주입 완료
- DB 연결 정상

---

# 4️⃣ 트래픽 흐름

최종 구조는 다음과 같다.

```
사용자
   ↓
EC2 Public IP
   ↓
Ingress-Nginx (WAF 적용)
   ↓
Kubernetes Service
   ↓
Pod (Flask API)
   ↓
RDS
```

---

# 5️⃣ 보안 적용 상태

- ModSecurity 활성화
- OWASP Core Rule Set 적용
- HTTPS(Self-signed) 활성화
- WAF 로그 stdout 출력
- Prometheus 연동 가능

---

# 6️⃣ 모니터링 상태

- Prometheus 메트릭 수집 가능
- Grafana 대시보드 확인 가능
- Ingress 요청 수 및 차단 수 확인 가능

---

# 7️⃣ 1단계~3단계 결과 요약

| 영역 | 결과 |
| --- | --- |
| Terraform | EC2 자동 생성 |
| GitHub Actions | CI/CD 자동화 |
| Ansible | 서버 구성 자동화 |
| Kubernetes | 클러스터 구성 완료 |
| WAF | 보안 통로 구성 |
| Monitoring | 메트릭 수집 및 시각화 |

---

이로써 1단계에서 시작한 자동화는 다음 상태에 도달한다.

- 버튼 한 번으로
- 인프라 생성
- 서버 구성
- Kubernetes 배포
- WAF 적용
- 모니터링 연결

까지 자동 수행된다.
