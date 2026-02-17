# 3-3. common 역할

`common` 역할은 **서버의 기본 실행 환경을 준비하는 단계**이다.

이 단계는 이후 모든 작업의 기반이 되며, 가장 먼저 실행된다.

---

# 1️⃣ 스왑 메모리 생성

EC2 인스턴스에 2GB 스왑 파일을 생성한다.

수행 작업:

- `/swapfile` 생성
- 권한 설정
- `mkswap`
- `swapon`
- `/etc/fstab`에 등록

의미는 다음과 같다.

- 메모리가 부족할 경우를 대비한다.
- Kubernetes 실행 시 메모리 부족으로 인한 오류를 방지한다.
- 작은 인스턴스(t3.small 등)에서 안정성을 높인다.

---

# 2️⃣ 기본 패키지 설치 (raw 사용)

다음 패키지를 설치한다.

- python3
- python3-pip
- git
- python3-libselinux

이 단계는 `raw` 모듈을 사용하여 실행된다.

이유는 다음과 같다.

- 초기 상태의 Amazon Linux에는 Ansible이 필요로 하는 Python 환경이 완전히 준비되어 있지 않을 수 있다.
- raw는 Python 모듈을 거치지 않고 직접 명령을 실행한다.
- 가장 기초적인 환경을 먼저 구성하기 위함이다.

---

# 3️⃣ pip 업그레이드 및 라이브러리 설치

pip을 통해 다음 라이브러리를 설치한다.

- pip
- kubernetes
- PyYAML

의미는 다음과 같다.

- Kubernetes 관련 Ansible 모듈이 동작할 수 있도록 한다.
- Helm 및 K8s 제어를 위한 Python 라이브러리를 준비한다.

---

# 4️⃣ Python 인터프리터 경로 고정

다음 설정을 적용한다.

```
ansible_python_interpreter: /usr/bin/python3
```

의미는 다음과 같다.

- Ansible이 정확한 Python 경로를 사용하도록 강제한다.
- Python 버전 혼동으로 인한 실행 오류를 방지한다.

---

# 역할 요약

| 작업 | 목적 |
| --- | --- |
| 스왑 생성 | 메모리 부족 대비 |
| 기본 패키지 설치 | Ansible 실행 환경 준비 |
| pip 라이브러리 설치 | Kubernetes 제어 준비 |
| 인터프리터 고정 | 실행 안정성 확보 |

---

`common` 단계가 완료되면

EC2는 Ansible이 안정적으로 동작할 수 있는 상태가 된다.
