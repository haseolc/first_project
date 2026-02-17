# 1. Terraform: 인프라 준비

Terraform을 사용하여 AWS 인프라를 생성하는 단계이다.  
이 단계에서는 네트워크 구성, 보안 그룹 설정, EC2 생성까지 수행한다.

---

## 📌 하위 문서

- [1-1. 사전 조건](./1-1_사전_조건.md)
- [1-2. 네트워크 선택](./1-2_네트워크_선택.md)
- [1-3. Security Group 설정](./1-3_Security_Group.md)
- [1-4. EC2 인스턴스 생성](./1-4_EC2_인스턴스_생성.md)
- [1-5. Terraform 실행 및 확인 절차](./1-5_Terraform_실행_및_확인.md)

---

## 🧭 단계 요약

Terraform 단계는 다음 순서로 진행된다.

1. 사전 조건 확인
2. 네트워크 선택 (Default VPC + Public Subnet)
3. Security Group 설정
4. EC2 인스턴스 생성
5. Terraform 실행 및 상태 검증

---

## 🎯 목표

이 단계가 완료되면:

- EC2 인스턴스가 생성된다.
- Public IP가 할당된다.
- SSH 접속이 가능하다.
- 이후 GitHub Actions 배포 대상 서버가 준비된다.
