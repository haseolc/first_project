# 3-1. Ansible 기본 구조

이 단계에서는 **Ansible이 어떤 구조로 구성되어 있고, 어떻게 실행되는지** 설명한다.

Ansible은 EC2에 접속하여 서버 설정과 Kubernetes 배포를 자동으로 수행하는 도구이다.

---

# 1️⃣ 디렉토리 구조

Ansible 디렉토리 구조는 다음과 같다.

```
ansible/
 ├── ansible.cfg
 ├── site.yml
 ├── inventory.ini (실행 시 동적 생성)
 └── roles/
      ├── common/
      ├── k3s/
      ├── helm/
      ├── monitoring/
      └── nginx_waf/
```

각 구성 요소의 역할은 다음과 같다.

- `ansible.cfg`
    
    Ansible의 기본 설정 파일이다.
    
- `site.yml`
    
    전체 실행 흐름을 정의한 메인 플레이북이다.
    
- `inventory.ini`
    
    배포 대상 서버 목록이다.
    
    GitHub Actions에서 실행 시점에 자동 생성된다.
    
- `roles/`
    
    서버 설정을 기능 단위로 나눈 디렉토리이다.
    

---

# 2️⃣ ansible.cfg 설정

`ansible.cfg`는 Ansible의 기본 동작 방식을 정의한다.

주요 설정은 다음과 같다.

- `inventory = ./inventory.ini`
    
    실행 시 생성된 inventory 파일을 사용한다.
    
- `roles_path = ./roles`
    
    roles 디렉토리를 기본 경로로 설정한다.
    
- `remote_user = ec2-user`
    
    EC2 접속 기본 사용자이다.
    
- `host_key_checking = False`
    
    SSH 접속 시 확인 메시지를 생략한다.
    
- `timeout = 60`
    
    SSH 연결 대기 시간 설정이다.
    

이 설정을 통해 자동화 환경에서 안정적으로 실행할 수 있도록 구성한다.

---

# 3️⃣ site.yml 실행 흐름

`site.yml`은 Ansible 실행의 시작점이다.

구조는 다음과 같다.

```
roles:  - common  - k3s  - helm  - monitoring  - nginx_waf
```

의미는 다음과 같다.

1. 먼저 OS 기본 환경을 준비한다.
2. Kubernetes(k3s)를 설치한다.
3. Helm을 설치한다.
4. 모니터링 스택을 구성한다.
5. WAF(Ingress-Nginx)를 설치하고 보안 설정을 적용한다.

이 순서대로 실행되며, 하나라도 실패하면 전체 실행이 중단된다.

---

이 단계의 목적은 **Ansible이 어떤 구조로 동작하는지 이해하는 것**이다.
