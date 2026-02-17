# 3-7. monitoring 역할

`monitoring` 역할은 **Kubernetes 클러스터와 WAF의 상태를 수집하고 시각화하기 위한 모니터링 환경을 구성하는 단계**이다.

이 단계의 목적은 다음과 같다.

- 클러스터 상태를 실시간으로 확인한다.
- WAF 및 Ingress의 메트릭을 수집한다.
- 시각적으로 확인 가능한 대시보드를 제공한다.

---

# 1️⃣ Prometheus 설치

Prometheus는 메트릭 수집 도구이다.

역할:

- Kubernetes 리소스 상태 수집
- Ingress-Nginx 메트릭 수집
- Pod/Node 상태 수집

설치 방식:

- Helm 차트를 이용해 설치된다.
- 일반적으로 release 이름은 `prometheus`로 지정된다.

이 release 이름은 매우 중요하다.

`nginx_waf` 역할에서 ServiceMonitor에 다음 라벨이 사용된다.

```
release: prometheus
```

이 값이 일치해야 Prometheus가 Ingress 메트릭을 수집할 수 있다.

---

# 2️⃣ Grafana 설치

Grafana는 시각화 도구이다.

역할:

- Prometheus가 수집한 메트릭을 대시보드 형태로 표현한다.
- CPU, Memory, Pod 상태 등을 시각화한다.
- WAF 트래픽, 요청 수, 차단 로그 등을 확인할 수 있다.

---

# 3️⃣ ServiceMonitor 설정

ServiceMonitor는 다음 역할을 한다.

- 특정 Kubernetes 서비스의 메트릭을 Prometheus가 수집하도록 연결한다.

nginx_waf 역할에서 metrics 설정이 활성화되어 있다.

```
metrics:enabled:trueserviceMonitor:enabled:trueadditionalLabels:release:prometheus
```

이 설정으로 인해:

- ingress-nginx의 메트릭이 Prometheus에 자동 연결된다.
- WAF 관련 지표가 수집된다.

---

# 4️⃣ 모니터링 구성의 의미

구조는 다음과 같다.

```
Ingress-Nginx → Metrics Endpoint → ServiceMonitor → Prometheus → Grafana
```

이 구조를 통해 다음이 가능해진다.

- 트래픽 증가 감지
- 403 응답 증가 확인
- Pod 상태 이상 탐지
- 리소스 사용량 모니터링

---

# 역할 요약

| 구성 요소 | 역할 |
| --- | --- |
| Prometheus | 메트릭 수집 |
| Grafana | 시각화 |
| ServiceMonitor | 메트릭 연결 |
| ingress metrics | WAF 트래픽 데이터 제공 |

---

이 단계가 완료되면

클러스터와 WAF 상태를 실시간으로 확인할 수 있는 환경이 구성된다.
