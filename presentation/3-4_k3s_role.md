# 3-4. k3s 역할

`k3s` 역할은 **EC2를 단일 노드 Kubernetes 서버로 변환하는 단계**이다.

이 단계가 완료되면 EC2는 단순 리눅스 서버가 아니라 Kubernetes 클러스터가 된다.

---

# 1️⃣ 기존 k3s 제거

먼저 기존 k3s 바이너리를 삭제한다.

목적은 다음과 같다.

- 이전 설치가 남아 있을 경우 충돌 방지
- 재실행 시 안정성 확보
- 항상 동일한 상태에서 설치 보장

---

# 2️⃣ k3s 설치

다음 스크립트를 통해 k3s를 설치한다.

- `curl -sfL https://get.k3s.io`
- `INSTALL_K3S_SKIP_SELINUX_RPM=true`
- `-disable traefik`

의미는 다음과 같다.

- 공식 설치 스크립트를 사용한다.
- SELinux 관련 충돌을 우회한다.
- 기본 Traefik Ingress를 비활성화한다.

Traefik을 비활성화하는 이유는 다음과 같다.

- 이후 단계에서 ingress-nginx(WAF)를 사용하기 위함이다.
- Ingress 충돌을 방지한다.

---

# 3️⃣ k3s 서비스 활성화

k3s 설치 후 다음을 수행한다.

- systemctl enable k3s
- systemctl start k3s

목적은 다음과 같다.

- 서버 재부팅 후에도 자동 실행되도록 설정
- 즉시 클러스터 구동

---

# 4️⃣ kubeconfig 설정

k3s 설치 후 생성되는 파일:

```
/etc/rancher/k3s/k3s.yaml
```

이를 ec2-user의 홈 디렉토리로 복사한다.

- `/home/ec2-user/.kube/config`

목적은 다음과 같다.

- 일반 사용자(ec2-user)가 kubectl 명령을 사용할 수 있도록 한다.
- 이후 Ansible에서 kubectl 실행이 가능하도록 한다.

또한 `.bashrc`에 다음을 추가한다.

```
export KUBECONFIG=$HOME/.kube/config
```

---

# 5️⃣ kubectl 심볼릭 링크 생성

다음 링크를 생성한다.

```
/usr/local/bin/kubectl→/usr/local/bin/k3s
```

의미는 다음과 같다.

- k3s 내부 kubectl을 표준 kubectl 명령처럼 사용 가능하게 한다.

---

# 6️⃣ infra.yml 배포

마지막으로 Kubernetes 리소스를 배포한다.

수행 작업:

1. `infra.yml`을 EC2로 복사
2. `kubectl apply -f infra.yml` 실행

이 파일에는 다음 리소스가 정의되어 있다.

- Secret
- Deployment
- Service
- Ingress

이 단계가 완료되면:

- Flask API 컨테이너가 실행된다.
- Kubernetes Service가 생성된다.
- Ingress 리소스가 생성된다.

---

# 역할 요약

| 단계 | 목적 |
| --- | --- |
| 기존 제거 | 재설치 안정성 확보 |
| k3s 설치 | Kubernetes 환경 구성 |
| 서비스 활성화 | 자동 실행 보장 |
| kubeconfig 설정 | 사용자 접근 가능 |
| kubectl 링크 | 명령어 표준화 |
| infra.yml 적용 | 애플리케이션 배포 |

---

이 단계가 완료되면

EC2는 Kubernetes 클러스터 + API가 배포된 상태가 된다.
