# 1-5. Terraform 실행 및 확인 절차

이 단계에서는 **Terraform을 실제로 실행하여 EC2를 생성하고, 정상 생성 여부를 확인한다.**

# 1️⃣ Terraform 초기화

Terraform 디렉토리로 이동하여 초기화를 수행한다.

```bash
cd terraform
terraform init
```

의미는 다음과 같다.

- 필요한 provider(AWS)를 다운로드한다.
- Terraform 실행 환경을 준비한다.

초기화는 프로젝트 최초 1회 수행하면 된다.

# 2️⃣ 인프라 생성

다음 명령으로 EC2를 생성한다.

```bash
terraform apply
```

자동 승인을 사용할 경우:

```bash
terraform apply -auto-approve
```

의미는 다음과 같다.

- Security Group 조회
- Public Subnet 조회
- EC2 인스턴스 생성
- Root Volume 생성
- 태그 적용

# 3️⃣ 생성 결과 확인

apply가 완료되면 출력값이 표시된다.

예시:

```
room7_public_ip ="3.35.xxx.xxx"
```

이 값은 반드시 확인해야 한다.

이 IP가:

- GitHub Actions의 deploy 단계에서 사용된다.
- SSH 접속 대상이 된다.
- Ansible 배포 대상이 된다.

# 4️⃣ AWS 콘솔에서 직접 확인

Terraform 출력 외에도 AWS 콘솔에서 다음을 확인한다.

### EC2 상태

- Instance state: running
- Status checks: 2/2 passed

### Public IP 존재 여부

- Public IPv4 address가 할당되어 있어야 한다.

### Security Group 연결

- ssh_sg
- web_sg

# 5️⃣ SSH 접속 테스트 (선택 확인)

로컬에서 직접 접속 테스트를 수행할 수 있다.

```bash
ssh -i <pem파일> ec2-user@<public_ip>
```

접속이 성공하면:

- 네트워크 정상
- Security Group 정상
- Key Pair 정상

이라는 의미이다.

이 단계까지 완료되면 **1. Terraform: 인프라 준비는 정상 동작 상태**이다.

다음부터는 **2. GitHub Actions 자동화 파이프라인**으로 넘어가면 된다.
