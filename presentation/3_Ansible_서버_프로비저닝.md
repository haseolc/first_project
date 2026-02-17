# 3. Ansible: 서버 프로비저닝 + K3s 배포

Ansible을 사용하여 EC2 서버를 구성하고, K3s 기반 Kubernetes 환경을 구축한 뒤 애플리케이션을 배포하는 단계이다.  

이 단계에서는 OS 환경 구성부터 Kubernetes 설치, Helm 설정, WAF 적용, 모니터링 구성까지 수행한다.

---

## 📌 하위 문서

- [3-1. Ansible 기본 구조](./3-1_ansible_structure.md)
- [3-2. site.yml 실행 순서](./3-2_site_execution_order.md)
- [3-3. common 역할](./3-3_common_role.md)
- [3-4. k3s 역할](./3-4_k3s_role.md)
- [3-5. 배포 매니페스트 (infra.yml)](./3-5_infra_manifest.md)
- [3-6. helm 역할](./3-6_helm_role.md)
- [3-7. monitoring 역할](./3-7_monitoring_role.md)
- [3-8. nginx_waf 역할](./3-8_nginx_waf_role.md)
- [3-9. 전체 실행 결과](./3-9_final_result.md)

---

## 🧭 단계 요약

Ansible 단계는 다음 순서로 진행된다.

1. OS 기본 환경 구성 (common)
2. K3s 설치 및 Kubernetes 클러스터 구성
3. Helm 설치 및 패키지 관리 환경 준비
4. 애플리케이션 매니페스트 배포
5. WAF(Ingress-Nginx + ModSecurity) 적용
6. Prometheus/Grafana 기반 모니터링 구성

---

## 🔄 전체 구성 흐름

EC2
↓
Ansible 실행
↓
K3s 설치
↓
Kubernetes 리소스 배포
↓
Ingress + WAF 적용
↓
Monitoring 구성


---

## 🎯 목표

이 단계가 완료되면 다음 상태가 된다.

- EC2는 단일 노드 Kubernetes 클러스터로 동작한다.
- Flask API가 컨테이너로 실행된다.
- Ingress-Nginx + ModSecurity가 적용된다.
- HTTPS 통신이 가능하다.
- Prometheus 및 Grafana로 모니터링이 가능하다.

즉, 서버는 단순 인스턴스가 아니라 **보안과 모니터링이 적용된 서비스 환경**으로 완성된다.
