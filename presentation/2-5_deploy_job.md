# 2-5. deploy job

이 단계에서는 **생성된 EC2에 접속하여 Ansible로 서버를 구성하고 배포를 수행한다.**

deploy job은 단순 접속이 아니라, 실제로 서버를 “완성 상태”로 만드는 단계이다.

---

## 2-5-1. SSH 접속 준비

이 단계에서는 GitHub Actions runner가 EC2에 접속할 수 있도록 환경을 만든다.

### 1️⃣ SSH 키 배치

GitHub Secrets에 저장된 `SSH_PRIVATE_KEY`를 runner 내부 파일로 저장한다.

- 저장 경로: `/home/runner/.ssh/id_rsa`
- 권한: `chmod 400`

이 설정이 없으면 SSH가 보안상 이유로 키 사용을 거부한다.

---

### 2️⃣ 포트 오픈 대기 (nc loop)

EC2는 생성 직후 바로 SSH가 열리지 않을 수 있다.

따라서 deploy job은 다음을 반복 수행한다.

- `nc -z -w 5 <EC2_PUBLIC_IP> 22`로 SSH 포트 확인
- 실패하면 10초 대기
- 최대 30회 반복

의미는 다음과 같다.

- EC2 부팅이 완료될 때까지 자동으로 기다린다.
- “부팅이 덜 된 상태에서 Ansible 실행”을 방지한다.

---

### 3️⃣ known_hosts 등록

SSH 접속 시 host key 확인으로 인해 자동화가 멈추는 것을 방지한다.

- `ssh-keyscan -H <EC2_PUBLIC_IP>` 실행
- 결과를 `~/.ssh/known_hosts`에 추가

이 단계가 없으면 “Are you sure you want to continue connecting” 같은 확인 단계에서 자동화가 중단될 수 있다.

---

### 4️⃣ inventory.ini 생성

Ansible이 배포할 대상 서버를 알 수 있도록 `inventory.ini`를 동적으로 생성한다.

생성 위치:

- `ansible/inventory.ini`

생성 내용:

- 그룹: `[k3s_cluster]`
- 호스트: `<EC2_PUBLIC_IP>`
- 사용자: `ec2-user`
- 키 경로: `/home/runner/.ssh/id_rsa`

이 과정이 중요한 이유는 다음과 같다.

- EC2 IP는 매번 바뀔 수 있다.
- 따라서 inventory를 미리 고정할 수 없다.
- 실행 시점에 자동으로 생성해야 한다.

---

## 2-5-2. Ansible 실행 준비

이 단계에서는 Ansible이 Kubernetes/Helm 관련 작업을 수행할 수 있도록 준비한다.

### 1️⃣ collection 설치

playbook에서 Kubernetes/Helm 모듈을 사용하므로 collection 설치가 필요하다.

- 설치 대상: `community.kubernetes`
- 설치 위치: `./ansible/collections`

이 단계가 없으면 `kubernetes.core.helm` 같은 모듈이 동작하지 않는다.

---

### 2️⃣ RDS endpoint 치환

Kubernetes 배포 YAML에서 DB 주소를 고정하지 않고, Terraform 결과값을 주입한다.

치환 대상 파일:

- `ansible/roles/k3s/infra.yml`

치환 내용:

- `__RDS_ENDPOINT__` → `${{ needs.terraform.outputs.RDS_ENDPOINT }}`

이 단계가 실패하면 다음 문제가 발생한다.

- API 컨테이너가 DB에 연결하지 못한다.
- 배포는 완료되어도 서비스가 정상 동작하지 않는다.

---

## 2-5-3. Ansible 실행

이 단계에서는 실제로 playbook을 실행한다.

실행 명령:

```bash
cd ansible
ansible-playbook -i inventory.ini site.yml
```

의미는 다음과 같다.

- inventory.ini에 등록된 EC2에 접속한다.
- `site.yml`에 정의된 roles를 순서대로 실행한다.
- 결과적으로 K3s 설치, Helm 설치, WAF 설정, 애플리케이션 배포까지 완료한다.

---

이 단계가 완료되면

EC2는 단순한 서버가 아니라, “서비스가 구동되는 완성된 환경”이 된다.
