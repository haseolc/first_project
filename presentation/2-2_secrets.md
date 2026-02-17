# 2-2. Secrets 목록

이 단계에서는 GitHub Actions가 실행될 때 필요한 **Secrets(비밀 값)** 목록을 정리한다.

Secrets는 GitHub에 저장되는 “로그인 정보/키”이며, 워크플로우 실행 중에만 참조된다.

---

# 1️⃣ AWS (Terraform 실행용)

Terraform job이 AWS에 접속하여 EC2를 생성하려면 AWS 인증 정보가 필요하다.

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

이 두 값이 없으면 Terraform apply가 실행되지 않는다.

---

# 2️⃣ Docker (이미지 업로드용)

build-and-push job이 Docker Hub에 로그인하여 이미지를 push하려면 Docker 인증 정보가 필요하다.

- `DOCKER_USERNAME`
- `DOCKER_TOKEN`

이 값이 없으면 Docker login 또는 push 단계에서 실패한다.

---

# 3️⃣ SSH (EC2 접속용)

deploy job이 Ansible을 실행하려면 EC2에 SSH로 접속해야 한다.

이를 위해 EC2 Key Pair에 대응하는 Private Key가 필요하다.

- `SSH_PRIVATE_KEY`

이 값이 없으면:

- SSH 접속 준비 단계에서 실패한다.
- inventory.ini를 만들더라도 접속 자체가 불가능하다.
- Ansible 배포가 진행되지 않는다.

---

# 4️⃣ Secrets 등록 위치

Secrets는 다음 경로에서 등록한다.

- GitHub Repository → **Settings**
- **Secrets and variables**
- **Actions**
- **New repository secret**

---

이 단계가 완료되면 GitHub Actions는 AWS/Docker/EC2에 접근할 수 있는 상태가 된다.
