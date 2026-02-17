# 1차 프로젝트: 1단계

본 문서는 1차 프로젝트의 1단계 전체 흐름을 정리한 문서이다.  
1단계는 인프라 생성부터 자동화 배포, Kubernetes 구성까지를 포함한다.

---

## 📌 구성 개요

1. [Terraform: 인프라 준비](./1_terraform.md)
2. [GitHub Actions: 자동화 파이프라인](./2_GitHub_Actions_자동화_파이프라인/)
3. [Ansible: 서버 프로비저닝 + K3s 배포](./3_Ansible_서버_프로비저닝/)
4. 검증 체크 리스트
5. Troubleshooting

---

## 📂 문서 구조

### 1. Terraform: 인프라 준비
- EC2 생성
- 네트워크 구성
- Security Group 설정
- Terraform 실행 및 확인 절차

➡️ 상세 문서 보기:  
`/1_Terraform_인프라/`

---

### 2. GitHub Actions: 자동화 파이프라인
- Docker 이미지 빌드
- Terraform 실행
- EC2 생성 후 자동 배포
- Ansible 실행 구조

➡️ 상세 문서 보기:  
`/2_GitHub_Actions_자동화_파이프라인/`

---

### 3. Ansible: 서버 프로비저닝 + K3s 배포
- OS 환경 구성
- K3s 설치
- Helm 설치
- WAF 적용
- 모니터링 구성

➡️ 상세 문서 보기:  
`/3_Ansible_서버_프로비저닝/`

---

## 🎯 1단계 최종 목표

버튼 한 번으로 다음이 자동 수행된다.

- Docker 이미지 빌드
- EC2 인프라 생성
- Kubernetes 구성
- 애플리케이션 배포
- WAF 적용
- 모니터링 환경 구성

---

## 📎 참고

본 문서는 노션 문서를 기반으로 Git 저장소에 맞게 재구성되었다.  
각 단계는 폴더 단위로 분리되어 있으며, 세부 문서는 해당 디렉토리에서 확인할 수 있다.
