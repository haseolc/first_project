# 2-4. terraform job

이 단계에서는 **Terraform을 실행하여 EC2를 생성하고, 이후 배포에 필요한 값을 추출한다.**

이 Job이 성공해야 서버가 준비되고, deploy 단계로 넘어갈 수 있다.

---

# 1️⃣ Terraform 초기화 및 실행

Terraform은 `terraform/` 디렉토리에서 실행된다.

실행 순서는 다음과 같다.

```
terraform init
terraform apply -auto-approve
```

의미는 다음과 같다.

- AWS provider를 초기화한다.
- EC2 인스턴스를 생성한다.
- 필요한 네트워크/보안 그룹을 조회하여 연결한다.
- Root Volume 및 태그를 설정한다.

이 단계가 실패하면:

- EC2가 생성되지 않는다.
- 이후 deploy 단계는 실행되지 않는다.

---

# 2️⃣ EC2 생성

apply가 성공하면 다음이 수행된다.

- Default VPC의 Public Subnet에 EC2 생성
- Public IP 자동 할당
- SSH 및 Web Security Group 연결
- user_data 실행

이 시점의 EC2는 “접속 가능한 빈 서버” 상태이다.

---

# 3️⃣ outputs 추출

Terraform 실행 후, 다음 값들을 추출하여 GitHub Actions의 output으로 저장한다.

---

## EC2_PUBLIC_IP

다음 명령으로 추출한다.

```
terraformoutput -raw room7_public_ip
```

이 값은:

- deploy 단계에서 SSH 접속 대상이 된다.
- Ansible inventory에 사용된다.

---

## RDS_ENDPOINT

다음 명령으로 추출한다.

```
terraformoutput -raw endpoint
```

이 값은:

- Kubernetes Deployment의 DB_HOST 값으로 사용된다.
- deploy 단계에서 `infra.yml`에 치환된다.

---

# 4️⃣ Job Output 전달 구조

terraform job은 다음 값을 다음 단계에 전달한다.

- `EC2_PUBLIC_IP`
- `RDS_ENDPOINT`

deploy job은 이 값을 `needs.terraform.outputs`로 참조한다.

이 구조의 의미는 다음과 같다.

- 인프라 생성 결과를 자동으로 다음 단계에 전달한다.
- IP나 endpoint를 수동으로 복사할 필요가 없다.
- 인프라 변경 시에도 자동 반영된다.

---

이 단계가 완료되면

서버 주소와 DB 주소가 모두 확보된 상태가 된다.
