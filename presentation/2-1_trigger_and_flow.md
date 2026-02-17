# 2-1. 트리거 & 전체 흐름

이 단계에서는 **GitHub Actions가 어떤 방식으로 시작되고, 어떤 순서로 실행되는지** 설명한다.

---

# 1️⃣ 트리거 방식

본 프로젝트의 GitHub Actions는 다음 방식으로 실행된다.

```
workflow_dispatch
```

의미는 다음과 같다.

- 자동 실행(push 시 실행)이 아니라
- 사용자가 직접 버튼을 눌러 실행하는 방식이다.
- GitHub → Actions 탭 → Run workflow 버튼을 눌러 시작한다.

이 방식을 사용하는 이유는 다음과 같다.

- 인프라 생성은 비용이 발생할 수 있기 때문에 자동 실행을 방지한다.
- 테스트 타이밍을 팀이 직접 제어할 수 있다.
- 실습/데모 환경에서 안전하다.

---

# 2️⃣ 전체 실행 흐름

GitHub Actions는 **3개의 Job**으로 구성된다.

실행 순서는 다음과 같다.

```
build-and-push → terraform → deploy
```

각 Job의 역할은 다음과 같다.

---

## build-and-push

- Flask API Docker 이미지를 빌드한다.
- Docker Hub에 업로드한다.

---

## terraform

- Terraform을 실행하여 EC2를 생성한다.
- 생성된 EC2 Public IP를 추출한다.
- (RDS 사용 시) RDS endpoint를 추출한다.

---

## deploy

- 생성된 EC2에 SSH로 접속한다.
- Ansible을 실행하여 서버를 완성한다.
- Kubernetes, WAF, API 배포까지 수행한다.

---

# 3️⃣ Job 의존성 구조

`deploy`는 `terraform`과 `build-and-push`가 모두 성공해야 실행된다.

즉,

- 이미지 빌드 실패 → 배포 중단
- EC2 생성 실패 → 배포 중단
- EC2 IP 확보 실패 → 배포 중단

이 구조의 목적은 다음과 같다.

- 인프라가 준비되지 않은 상태에서 배포를 방지한다.
- 잘못된 이미지로 서버를 구성하는 것을 방지한다.
- 자동화 흐름을 안전하게 제어한다.

---

이 단계는 **“자동화가 어떤 순서로 움직이는지 이해하는 단계”**이다.
