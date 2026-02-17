# 3-8. nginx_waf 역할

`nginx_waf` 역할은 **외부 트래픽을 제어하는 Ingress Controller를 설치하고, WAF 기능을 활성화하는 단계**이다.

이 단계가 완료되면 애플리케이션은 보안 통로 뒤에서 동작하게 된다.

---

# 1️⃣ ingress-nginx 설치

Helm을 사용하여 ingress-nginx를 설치한다.

설정 특징:

- Controller 종류: `DaemonSet`
- `hostNetwork: true`
- `ingressClassResource.name: nginx`
- `default: true`
- `watchIngressWithoutClass: true`

의미는 다음과 같다.

- 각 노드에서 직접 네트워크를 사용한다.
- `nginx`라는 Ingress Class를 기본값으로 설정한다.
- Ingress에 별도 클래스 지정이 없어도 감시한다.

---

# 2️⃣ ModSecurity 활성화

WAF 기능을 활성화한다.

주요 설정:

- `enable-modsecurity: true`
- `enable-owasp-modsecurity-crs: true`

의미는 다음과 같다.

- ModSecurity 엔진을 활성화한다.
- OWASP Core Rule Set을 적용한다.
- SQL Injection, XSS 등 기본적인 공격 패턴을 차단한다.

---

# 3️⃣ ModSecurity 설정 스니펫

다음 설정이 적용된다.

```
SecRuleEngineOn
SecRequestBodyAccessOn
SecAuditEngine RelevantOnly
SecAuditLog /dev/stdout
```

의미는 다음과 같다.

- 요청 검사 활성화
- 요청 본문 검사 활성화
- 관련 로그만 기록
- 로그를 stdout으로 출력

이 설정을 통해 WAF 차단 로그를 확인할 수 있다.

---

# 4️⃣ Metrics 활성화

다음 설정이 포함되어 있다.

```
metrics.enabled:trueserviceMonitor.enabled:truerelease:prometheus
```

의미는 다음과 같다.

- Ingress 메트릭 수집 가능
- Prometheus와 자동 연동
- WAF 차단 수, 요청 수 등을 모니터링 가능

---

# 5️⃣ TLS Secret 생성

자체 서명(Self-signed) 인증서를 생성하고 Kubernetes Secret으로 등록한다.

생성 결과:

- `waf-tls-secret`

의미는 다음과 같다.

- HTTPS(443) 접근 가능
- 테스트 환경에서 암호화 통신 제공
- 브라우저 경고는 발생할 수 있음

---

# 전체 트래픽 흐름

설치 완료 후 구조는 다음과 같다.

```
사용자 →Ingress-Nginx(WAF) → Service →Pod(API)
```

모든 외부 요청은 다음 과정을 거친다.

1. WAF에서 공격 패턴 검사
2. 정상 요청만 내부 서비스로 전달
3. API가 RDS와 통신

---

# 역할 요약

| 기능 | 목적 |
| --- | --- |
| ingress-nginx 설치 | 외부 트래픽 진입점 구성 |
| ModSecurity 활성화 | 공격 차단 |
| OWASP CRS 적용 | 기본 보안 룰 적용 |
| TLS Secret 생성 | HTTPS 통신 지원 |
| Metrics 연동 | 모니터링 가능 |

---

이 단계가 완료되면

애플리케이션은 WAF 뒤에서 보호된 상태로 외부에 노출된다.
