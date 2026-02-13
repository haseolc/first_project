# Automated Cloud Infrastructure with Security & Backup

AWS 인프라를 Terraform과 Ansible로 자동화하고, Kubernetes 환경에 애플리케이션을 배포했습니다.
보안 그룹 설계와 WAF, RDS 자동 백업, Grafana/Prometheus 모니터링을 적용하여, 수동 콘솔 작업 없이 재현 가능하고 안전한 클라우드 아키텍처를 구축했습니다.

## ◆ Architecture Overview
### Infrastructure Components

- IaC: Terraform
- Configuration Management: Ansible
- Compute: EC2
- Database: Amazon RDS (MySQL)
- Container Orchestration: Kubernetes (K3s)
- Monitoring: Prometheus + Grafana
- CI/CD: GitHub Actions
- Security & Backup: GitHub Secrets, WAF (ModSecurity), RDS 자동 백업

### Tools Used
![Terraform](https://img.shields.io/badge/-Terraform-623CE4?style=flat&logo=terraform&logoColor=white&labelColor=623CE4)
![Ansible](https://img.shields.io/badge/-Ansible-000000?style=flat&logo=ansible&logoColor=white&labelColor=000000)
![GitHub Actions](https://img.shields.io/badge/-GitHub_Actions-2088FF?style=flat&logo=github-actions&logoColor=white)
![AWS](https://img.shields.io/badge/-AWS-232F3E?style=flat&logo=amazon-aws&logoColor=white&labelColor=232F3E)
![Kubernetes](https://img.shields.io/badge/-Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white&labelColor=326CE5)
![Grafana](https://img.shields.io/badge/-Grafana-F46800?style=flat&logo=grafana&logoColor=white&labelColor=F46800)
![Prometheus](https://img.shields.io/badge/-Prometheus-E6522C?style=flat&logo=prometheus&logoColor=white&labelColor=E6522C)

## ◆ Infrastructure Design Highlights
### Network & Security

- GitHub Secrets 기반 민감정보 관리
- WAF(ModSecurity) 적용 Kubernetes Ingress Controller로 애플리케이션 보호
- RDS를 Private Subnet에 배치하고 외부 직접 접근 차단
- EC2 ↔ RDS 간 Security Group 참조 방식 적용

### Backup Strategy
- Amazon RDS 자동 백업 구성 및 스냅샷 정책 설계
- 재해 복구와 데이터 안정성 확보

### Infrastructure as Code

- Terraform 모듈 분리 및 단계적 배포로 State 충돌 방지
  - Branch: ```feature/sg```, ```feature/rds```, ```main```
- GitHub Actions 기반 자동 배포 파이프라인 구축

### Monitoring

- Prometheus 메트릭 수집
- Grafana 대시보드 구성
- Kubernetes Pod / Service 상태 모니터링

## ◆ Deployment Process

1. Security Group 배포

   ```
   Branch: feature/sg → Run Workflow
   ```
2. RDS 배포

   ```
   Branch: feature/rds → Run Workflow
   ```

3. 애플리케이션 & 인프라 배포

   ```
   Branch: main → Run Workflow
   ```

4. 웹 접속

   ```
   http://<PUBLIC_IPV4_ADDRESS>
   ```

## ◆ Troubleshooting

프로젝트 진행 중 발생한 이슈 및 해결 과정은 아래에 정리했습니다.

[![Notion](https://img.shields.io/badge/-Notion-17191A?style=flat&logo=notion&logoColor=white&labelColor=17191A)](https://www.notion.so/troubleshooting-fed8a2d6b91883eead9081ae5d7ee963?source=copy_link)

## ◆ Resource Cleanup Guide

> [!NOTE]
> 비용 발생 방지를 위해 삭제 시 아래 순서를 따릅니다.

1. EC2 인스턴스 종료
 
2. RDS 삭제
   - RDS 인스턴스 삭제
   - 스냅샷 전부 삭제
   - DB Subnet Group 삭제

3. VPC Private Subnet 삭제

4. Security Group 삭제

