# 3-6. helm 역할

`helm` 역할은 **Kubernetes에 패키지 단위로 애플리케이션을 설치할 수 있도록 Helm을 준비하는 단계**이다.

Helm은 Kubernetes의 패키지 매니저 역할을 한다.

---

# 1️⃣ 기존 Helm 제거

다음 경로의 기존 Helm 바이너리를 제거한다.

- `/usr/local/bin/helm`
- `/usr/bin/helm`

목적은 다음과 같다.

- 이전 설치와의 충돌 방지
- 경로 중복 문제 방지
- 항상 동일한 상태에서 설치 보장

---

# 2️⃣ Helm 설치

공식 설치 스크립트를 사용하여 최신 Helm을 설치한다.

```
curl -fsSLhttps://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

설치 후 심볼릭 링크를 생성한다.

```
/usr/local/bin/helm→/usr/bin/helm
```

의미는 다음과 같다.

- 어느 경로에서든 helm 명령을 사용할 수 있다.
- 시스템 PATH 충돌을 방지한다.

---

# 3️⃣ Helm 버전 확인

설치 후 다음 명령으로 정상 설치 여부를 확인한다.

```
helm version
```

이 단계는 설치가 정상적으로 완료되었는지 검증하기 위함이다.

---

# 4️⃣ ingress-nginx 저장소 추가

다음 Helm 저장소를 추가한다.

```
helm repoadd ingress-nginx https://kubernetes.github.io/ingress-nginx
```

의미는 다음과 같다.

- ingress-nginx 차트를 설치할 준비를 한다.
- 이후 nginx_waf 역할에서 이 저장소를 사용한다.

---

# 역할 요약

| 단계 | 목적 |
| --- | --- |
| 기존 제거 | 충돌 방지 |
| Helm 설치 | Kubernetes 패키지 관리 준비 |
| 버전 확인 | 설치 검증 |
| repo 추가 | ingress-nginx 설치 기반 마련 |

---

이 단계가 완료되면

Kubernetes에 Helm 차트를 이용해 애플리케이션을 설치할 수 있는 상태가 된다.
