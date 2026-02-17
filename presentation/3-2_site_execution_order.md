# 3-2. site.yml 실행 순서

이 단계에서는 `site.yml`에 정의된 **roles 실행 순서와 그 이유**를 설명한다.

Ansible은 위에서 아래 순서대로 역할을 수행한다.

실행 순서는 다음과 같다.

```
common → k3s → helm → monitoring → nginx_waf
```

이 순서는 의도적으로 구성된 것이다. 순서를 변경하면 오류가 발생할 수 있다.

---

# 1️⃣ common

가장 먼저 실행된다.

역할:

- 스왑 메모리 생성
- 기본 패키지 설치
- Python 및 pip 환경 구성

이 단계의 목적은 다음과 같다.

- 이후 role들이 정상적으로 실행될 수 있도록 OS 환경을 준비한다.
- Kubernetes 및 Helm 모듈이 동작할 수 있는 기반을 만든다.

이 단계가 실패하면 이후 모든 작업이 실패한다.

---

# 2️⃣ k3s

두 번째로 실행된다.

역할:

- 기존 k3s 제거
- k3s 설치
- kubeconfig 설정
- Kubernetes 리소스 배포(infra.yml 적용)

이 단계의 목적은 다음과 같다.

- EC2를 단일 노드 Kubernetes 클러스터로 변환한다.
- 애플리케이션이 배포될 실행 환경을 만든다.

k3s가 준비되지 않으면 Helm이나 Ingress 설정이 불가능하다.

---

# 3️⃣ helm

세 번째로 실행된다.

역할:

- Helm 설치
- ingress-nginx Helm 저장소 등록

이 단계의 목적은 다음과 같다.

- Kubernetes에 패키지 단위로 애플리케이션을 설치할 수 있도록 준비한다.
- WAF 설치를 위한 기반을 만든다.

Helm은 Kubernetes 위에서 동작하므로 k3s 이후에 실행되어야 한다.

---

# 4️⃣ monitoring

네 번째로 실행된다.

역할:

- Prometheus 설치
- Grafana 설치
- ServiceMonitor 설정

이 단계의 목적은 다음과 같다.

- 클러스터와 WAF의 메트릭을 수집한다.
- 시각화 환경을 구성한다.

모니터링은 Kubernetes가 준비된 이후에만 동작 가능하다.

---

# 5️⃣ nginx_waf

마지막으로 실행된다.

역할:

- ingress-nginx 설치
- ModSecurity 활성화
- OWASP CRS 적용
- TLS Secret 생성

이 단계의 목적은 다음과 같다.

- 외부 트래픽을 WAF를 통해 필터링한다.
- 애플리케이션을 보안 통로 뒤에 배치한다.

WAF는 Kubernetes와 Helm이 준비된 상태에서만 정상 동작한다.

---

# 실행 순서 요약

| 순서 | 역할 | 목적 |
| --- | --- | --- |
| 1 | common | OS 준비 |
| 2 | k3s | Kubernetes 환경 구성 |
| 3 | helm | Helm 기반 설치 준비 |
| 4 | monitoring | 모니터링 구성 |
| 5 | nginx_waf | 보안 인그레스 구성 |

---

이 단계의 핵심은 다음이다.

Ansible은 단순히 설정을 나열하는 것이 아니라,

**의존성에 맞춰 단계적으로 서버를 완성해 가는 구조**이다.
