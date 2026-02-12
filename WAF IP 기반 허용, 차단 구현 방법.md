WAF IP 기반 허용/차단 구현 방법
개요

AWS 보안 그룹과 Kubernetes NGINX Ingress WAF 설정을 이용하여
특정 공인 IP만 접근을 허용하고, 그 외 IP는 403 Forbidden으로 차단하도록 구성한다.

1. AWS 보안 그룹 설정
대상

EC2 인스턴스 보안 그룹: web_sg_7th_room

인바운드 규칙 추가

HTTP (80) → Source: 0.0.0.0/0

HTTPS (443) → Source: 0.0.0.0/0

설정 이유

HTTP/HTTPS 인바운드가 없으면:

차단 시 403 Forbidden이 아니라 Timeout 발생

WAF 동작을 가시적으로 확인하기 위해
→ 403 응답이 보이도록 인바운드 허용 후 WAF에서 차단

2. Kubernetes Ingress WAF 화이트리스트 설정
Ingress 수정
kubectl edit ingress myapi-waf-ingress

annotations 추가

기존:

metadata:
  annotations:
    nginx.ingress.kubernetes.io/enable-modsecurity: "true"


아래 1줄 추가:

    nginx.ingress.kubernetes.io/whitelist-source-range: "<본인 공인 IP>/32"

결과

<본인 공인 IP> → 접근 허용

그 외 모든 IP → 403 Forbidden 차단

3. 외부 접속 테스트를 위한 NodePort 노출
문제 상황

현재 Service TYPE = ClusterIP

Address: 10.43.xx.xx → 클러스터 내부 IP

외부에서 직접 접근 불가

→ 외부 데모를 위해 Ingress Controller를 NodePort로 변경 필요

NodePort 패치
kubectl -n ingress-nginx patch svc nginx-waf-ingress-nginx-controller \
  -p '{"spec":{"type":"NodePort","externalTrafficPolicy":"Local"}}'

NodePort 확인
kubectl -n ingress-nginx get svc nginx-waf-ingress-nginx-controller

예시 결과

HTTP: 32544

HTTPS: 31416

4. 접속 테스트 시나리오
허용 IP 테스트

환경: 본인 공인 IP

결과: 정상 접속 가능

차단 IP 테스트

환경: 휴대폰 LTE/5G 등 다른 네트워크

결과: 403 Forbidden 반환 (WAF 차단 확인)

최종 결과
구분	동작
허용된 공인 IP	정상 접근
비허용 IP	403 Forbidden 차단
보안 그룹 미허용 상태	Timeout 발생

→ WAF 기반 IP 접근 제어 정상 동작 확인
