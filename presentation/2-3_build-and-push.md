# 2-3. build-and-push

이 단계에서는 GitHub Actions가 **애플리케이션 Docker 이미지를 빌드하고 Docker Hub에 업로드**한다.

이 단계가 성공해야 이후 단계에서 Kubernetes에 배포할 이미지가 준비된다.

---

# 1️⃣ 실행 위치 및 기본 흐름

Job 이름은 다음과 같다.

- `build-and-push`

기본 흐름은 다음 순서로 실행된다.

1. 저장소 코드 체크아웃
2. Docker Hub 로그인
3. Docker 이미지 빌드
4. Docker Hub로 push

---

# 2️⃣ Docker build context

Docker 이미지는 다음 경로를 기준으로 빌드된다.

```
context: ./myapp/api
```

의미는 다음과 같다.

- Dockerfile 및 애플리케이션 소스는 `myapp/api` 아래에 존재해야 한다.
- 이 경로가 틀리면 빌드 단계에서 실패한다.

---

# 3️⃣ tag 규칙

빌드된 이미지는 다음 이름으로 Docker Hub에 업로드된다.

```
${DOCKER_USERNAME}/myapi:latest
```

의미는 다음과 같다.

- Docker Hub 계정(`DOCKER_USERNAME`)의 repository에 업로드된다.
- 이미지 이름은 `myapi`이다.
- tag는 `latest`이다.
- 배포 시에는 이 tag를 기준으로 항상 최신 이미지를 가져오게 된다.

---

# 4️⃣ Docker Hub push

이 단계에서는 `push: true`로 설정되어 있어 빌드가 끝나면 자동으로 Docker Hub에 업로드된다.

성공하면 다음이 보장된다.

- Kubernetes 배포에서 사용할 이미지가 준비된다.
- 이후 단계에서 `imagePullPolicy: Always`로 최신 이미지를 내려받을 수 있다.

실패하면 다음 단계로 진행하지 않는다.

- 이미지가 없으므로 배포가 불가능하다.

---

이 단계가 완료되면 Docker Hub에 최신 애플리케이션 이미지가 존재하게 된다.
