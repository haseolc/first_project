
### 1. Helm(헬름) 설치 확인
가장 먼저 패키지 매니저인 Helm이 서버에 잘 안착했는지 확인합니다.

```bash
# 1. Helm 버전 확인 (바이너리 설치 여부)
helm version

# 2. 추가한 레포지토리 목록 확인 (ingress-nginx가 있어야 함)
sudo helm repo list
```

---

### 2. Nginx Ingress Controller 설치 확인
쿠버네티스 내부에서 Nginx가 정상적으로 가동 중인지 확인합니다.

```bash
# 1. 인그레스 컨트롤러 Pod 상태 확인 (STATUS가 Running이어야 함)
kubectl get pods -n ingress-nginx

# 2. 서비스 및 포트 확인 (외부 접속용 NodePort 확인)
kubectl get svc -n ingress-nginx
```

---

### 3. ModSecurity(WAF) 활성화 확인

#### ① 로그를 통한 확인 (실시간 로그 감시)
Nginx가 뜰 때 ModSecurity를 로드했는지 로그에서 확인합니다.
```bash
# 인그레스 컨트롤러 로그에서 ModSecurity 문구 찾기
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx | grep -i "ModSecurity"
```
*   결과에 `ModSecurity-nginx v1.x.x` 또는 `ModSecurity v3.x.x` 관련 문구가 나오면 성공입니다.

#### ② 설정 파일 내부 확인
Nginx 컨테이너 안으로 들어가서 설정 파일에 `modsecurity on;` 문구가 있는지 직접 봅니다.
```bash
# Nginx 설정 파일에서 modsecurity 설정 여부 검색
kubectl exec -it -n ingress-nginx  $(kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}') -- nginx -T | grep -i "modsecurity"
```
*   `modsecurity on;` 과 `modsecurity_rules_file ...` 문구가 보이면 엔진이 활성화된 것입니다.

---

### 4. [매우 중요] 보안 담당자의 "실전 해킹 테스트"


#### ① 정상 접속 테스트
```bash
# EC2의 퍼블릭 IP로 접속 (200 OK가 나와야 함)
curl -I http://3.38.190.34
curl -I http://x.x.x.x:80 (혹은 다른 포트)
```

#### ② SQL Injection 공격 테스트 (WAF 차단 확인)

```bash
# 고의적인 SQL 인젝션 쿼리 전송
curl -I "http://3.38.190.34/?id='OR+1=1--"
```
*   **성공 결과:** `HTTP/1.1 403 Forbidden`이 출력되어야 합니다.
*   **실패 결과:** `HTTP/1.1 200 OK`나 `404 Not Found`가 나오면 WAF가 작동하지 않는 것입니다.

---

### 5. 보안 로그 확인 (Audit Log)

```bash
# 차단 기록 실시간 모니터링
kubectl logs -f -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```
