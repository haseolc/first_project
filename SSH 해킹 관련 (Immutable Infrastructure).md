SSH 침해 대응 시나리오 (Immutable Infrastructure 기반)
개요

허용되지 않은 IP에서 SSH 로그인 성공 이벤트가 발생하면
해당 인스턴스의 무결성을 더 이상 신뢰하지 않고 폐기 후 재생성한다.

이는 실제 해킹 여부와 무관하게,
정책 위반 인증 성공 자체를 침해 의심 이벤트로 간주하는
Immutable Infrastructure 보안 원칙에 따른 대응이다.

1. 정상 상태

SSH 접근: 허용된 공인 IP에서만 사용

애플리케이션: EC2에서 정상 운영

데이터베이스: RDS에 분리 저장

➡️ 서버 장애 시에도 데이터 영속성 보장

2. 이상 이벤트 정의
정책 위반 이벤트

허용되지 않은 IP에서 SSH 로그인 성공 발생

핵심 해석

실제 해킹 여부는 중요하지 않음

정책상 허용되지 않은 인증 성공 자체가 침해 의심

즉,

“모르는 IP라서 삭제”가 아니라
“정책을 위반한 인증 성공이 발생했으므로 무결성 불신 → 폐기”

3. 판단 논리 (Immutable 관점)
단계	판단
비허용 IP 로그인 성공	침해 의심
인스턴스 무결성	신뢰 불가
대응 원칙	수정하지 않고 폐기 후 재생성

➡️ Immutable Infrastructure 보안 모델 적용

4. 대응 절차
4.1 격리

보안 그룹에서 SSH(22) 차단

4.2 폐기

기존 EC2 인스턴스 삭제

4.3 재생성

Terraform으로 신규 EC2 생성

GitHub Actions + Ansible 자동 배포 수행

➡️ 사람의 수동 개입 없이 동일 환경 복원

5. 서비스 복구
구성 요소	상태
애플리케이션	자동 재설치
데이터베이스	RDS 재연결
서비스	정상 동작

➡️ 데이터 손실 없음

6. SSH 모의침투 시 Grafana 가시화 항목
6.1 SSH 로그인 성공 이벤트 (IP 기준)

Accepted publickey 로그 카운트

Source IP별 로그인 성공 횟수

6.2 SSH 로그인 실패 급증 (브루트포스 시나리오)

Failed password

Invalid user

분당 실패 횟수 증가

➡️ 공격 시도 탐지 지표

6.3 비허용 IP 로그인 성공 카운트 (핵심 이상 지표)
정책 정의

허용 IP: <공인 IP>

비허용 IP 로그인 성공:
→ Unauthorized SSH Success = 이상 이벤트

6.4 인스턴스 교체 전/후 비교
시각화 항목

Instance ID 변경

Uptime 초기화

Node Exporter uptime metric

➡️ Immutable 재생성 증거 제공

7. 모의침투 데모 시나리오 (권장 흐름)
Step 1

외부(비허용 IP)에서 SSH 로그인 성공 발생

Step 2 — Grafana 확인

Unauthorized SSH Success = 1

Step 3 — 자동 대응

Terraform destroy → apply

신규 인스턴스 재생성

Step 4 — Grafana 재확인

Instance ID 변경

Uptime 리셋

Step 5 — 서비스 검증

API 정상 응답 확인

최종 보안 의미

서버는 신뢰 대상이 아니라 폐기 가능한 자원이다.
침해 의심 시 치료가 아니라 교체가 정답이다.

➡️ Immutable Infrastructure 기반 보안 대응 완성
