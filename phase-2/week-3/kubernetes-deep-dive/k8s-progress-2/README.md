# Task Submission Template

> Mỗi task = 1 thư mục con + 1 PR/MR riêng. Copy template này vào `README.md` của task.

## Task: `Kubernetes Deep Dive — Day 4 Storage + Day 5 RBAC/NetworkPolicy + Weekend Helm`

- **Intern**: `Hà Thị Kim Oanh`
- **Phase / Week / Day**: `Phase 2 / Week 3 / Day 4-5 + Weekend`
- **Branch**: `phase-2/week-3/kubernetes-deep-dive`
- **Submitted at**: `2026-07-09 16:00` (timezone +07)
- **Time spent**: `7`

## 1. Mục tiêu

Hoàn thành các phần Kubernetes core nâng cao gồm Storage, RBAC, NetworkPolicy và Helm chart basic.  
Kết quả cần đạt: PostgreSQL persist data bằng PVC, user readonly không sửa được resource, NetworkPolicy chỉ cho app truy cập db, và Helm chart install/upgrade được bằng các file values khác nhau.

## 2. Cách chạy

### 2.1. Kiểm tra tool

```bash
docker --version
kubectl version --client
k3d version
helm version
```

### 2.2. Tạo cluster k3d nếu chưa có

```bash
k3d cluster create dev \
  --agents 2 \
  -p "8080:80@loadbalancer" \
  -p "8443:443@loadbalancer" \
  --k3s-arg "--disable=traefik@server:0"
```

Kiểm tra cluster:

```bash
kubectl cluster-info
kubectl get nodes -o wide
```

### 2.3. Tạo namespace

```bash
kubectl create namespace demo --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace access-lab --dry-run=client -o yaml | kubectl apply -f -
```

### 2.4. Chạy Day 4 — PostgreSQL với PVC

```bash
kubectl apply -f day-4-storage/manifests/postgres-secret.yaml
kubectl apply -f day-4-storage/manifests/postgres-pvc.yaml
kubectl apply -f day-4-storage/manifests/postgres.yaml

kubectl rollout status deployment/postgres -n demo
kubectl get pod,pvc,svc -n demo
```

Test data persist sau xoá Pod:

```bash
PG_POD="$(kubectl get pod -n demo -l app=postgres -o jsonpath='{.items[0].metadata.name}')"
echo $PG_POD

kubectl exec -n demo "$PG_POD" -- \
  psql -U appuser -d appdb -c "CREATE TABLE IF NOT EXISTS notes(id SERIAL PRIMARY KEY, text TEXT);"

kubectl exec -n demo "$PG_POD" -- \
  psql -U appuser -d appdb -c "INSERT INTO notes(text) VALUES ('data should persist after pod delete');"

kubectl exec -n demo "$PG_POD" -- \
  psql -U appuser -d appdb -c "SELECT * FROM notes;"

kubectl delete pod -n demo "$PG_POD"
kubectl rollout status deployment/postgres -n demo

PG_POD_NEW="$(kubectl get pod -n demo -l app=postgres -o jsonpath='{.items[0].metadata.name}')"
echo $PG_POD_NEW

kubectl exec -n demo "$PG_POD_NEW" -- \
  psql -U appuser -d appdb -c "SELECT * FROM notes;"
```

### 2.5. Chạy Day 5 — RBAC

```bash
kubectl apply -f day-5-rbac-networkpolicy/manifests/serviceaccounts.yaml
kubectl apply -f day-5-rbac-networkpolicy/manifests/rbac.yaml

kubectl get sa,role,rolebinding -n access-lab
```

Test quyền readonly/readwrite:

```bash
kubectl auth can-i get pods \
  --as=system:serviceaccount:access-lab:readonly-sa \
  -n access-lab

kubectl auth can-i create configmap \
  --as=system:serviceaccount:access-lab:readonly-sa \
  -n access-lab

kubectl auth can-i create configmap \
  --as=system:serviceaccount:access-lab:readwrite-sa \
  -n access-lab
```

Kết quả mong đợi:

```text
yes
no
yes
```

### 2.6. Chạy Day 5 — NetworkPolicy

```bash
kubectl apply -f day-5-rbac-networkpolicy/manifests/app-db.yaml
kubectl get pod,svc -n access-lab -o wide
```

Test trước NetworkPolicy:

```bash
kubectl exec -n access-lab app -- wget -qO- --timeout=3 http://db
kubectl exec -n access-lab random-client -- wget -qO- --timeout=3 http://db
```

Apply deny-all:

```bash
kubectl apply -f day-5-rbac-networkpolicy/manifests/deny-all.yaml

kubectl exec -n access-lab app -- wget -qO- --timeout=3 http://db || echo "blocked"
kubectl exec -n access-lab random-client -- wget -qO- --timeout=3 http://db || echo "blocked"
```

Allow app to db:

```bash
kubectl apply -f day-5-rbac-networkpolicy/manifests/allow-app-to-db.yaml

kubectl exec -n access-lab app -- wget -qO- --timeout=3 http://db
kubectl exec -n access-lab random-client -- wget -qO- --timeout=3 http://db || echo "blocked"
```

Kết quả mong đợi:

- Pod `app` truy cập được `db`.
- Pod `random-client` bị block.

### 2.7. Chạy Weekend — Helm chart

```bash
cd weekend-helm

helm lint demo-app
helm template demo-app ./demo-app -f values/dev.yaml

kubectl create namespace helm-dev --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install demo-app ./demo-app \
  -n helm-dev \
  -f values/dev.yaml

helm list -n helm-dev
kubectl get all,ingress -n helm-dev
```

Test ingress nếu ingress-nginx đã được cài:

```bash
echo "127.0.0.1 dev.demo.local stg.demo.local prd.demo.local" | sudo tee -a /etc/hosts

curl -H "Host: dev.demo.local" http://localhost:8080
```

Upgrade bằng staging và production values:

```bash
helm upgrade demo-app ./demo-app \
  -n helm-dev \
  -f values/stg.yaml

kubectl get deploy,pod,ingress -n helm-dev

helm upgrade demo-app ./demo-app \
  -n helm-dev \
  -f values/prd.yaml

kubectl get deploy,pod,ingress -n helm-dev
```

Package chart:

```bash
helm package demo-app
ls -lh *.tgz
```

## 3. Kết quả

- Screenshot / log output kèm trong `./screenshots/`.
- PostgreSQL chạy được với PVC và dữ liệu vẫn còn sau khi xoá Pod.
- RBAC test cho thấy `readonly-sa` không tạo được ConfigMap, còn `readwrite-sa` tạo được.
- NetworkPolicy test cho thấy Pod `db` chỉ nhận traffic từ Pod `app`.
- Helm chart `demo-app` install được vào namespace sạch `helm-dev`.
- Helm chart upgrade được bằng `dev.yaml`, `stg.yaml`, `prd.yaml`.
- Helm chart package được thành file `.tgz`.

## 4. Khó khăn & cách giải quyết

- **Vấn đề 1: PVC chưa Bound ngay.**  
  Cách fix: kiểm tra `kubectl get storageclass`, `kubectl describe pvc postgres-data -n demo`, sau đó chờ local-path provisioner tạo PV.

- **Vấn đề 2: PostgreSQL mất data sau khi xoá Pod.**  
  Cách fix: kiểm tra `volumeMounts.mountPath` và `persistentVolumeClaim.claimName`, đảm bảo Postgres đang ghi dữ liệu vào PVC.

- **Vấn đề 3: RBAC readonly vẫn sửa được resource.**  
  Cách fix: kiểm tra lại `Role` của `readonly-role`, chỉ để verbs `get`, `list`, `watch`; không thêm `create`, `update`, `patch`, `delete`.

- **Vấn đề 4: NetworkPolicy không block traffic.**  
  Cách fix: kiểm tra CNI có support NetworkPolicy không. Với k3d/k3s, nếu NetworkPolicy không hoạt động đúng thì cần dùng CNI hỗ trợ NetworkPolicy như Calico/Cilium hoặc cấu hình lại cluster.

- **Vấn đề 5: Helm ingress không truy cập được.**  
  Cách fix: kiểm tra ingress-nginx đã chạy chưa, kiểm tra `/etc/hosts`, kiểm tra host header và port `8080`.

## 5. Reference

- Kubernetes StorageClass: https://kubernetes.io/docs/concepts/storage/storage-classes/
- Kubernetes Persistent Volumes / PVC: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
- Kubernetes Secrets: https://kubernetes.io/docs/concepts/configuration/secret/
- Kubernetes RBAC: https://kubernetes.io/docs/reference/access-authn-authz/rbac/
- Kubernetes NetworkPolicy: https://kubernetes.io/docs/concepts/services-networking/network-policies/
- Helm chart template guide: https://helm.sh/docs/chart_template_guide/
- Helm commands: https://helm.sh/docs/helm/

## 6. Self-check

- [ ] Code chạy được trên máy sạch.
- [ ] README có hướng dẫn run lại.
- [ ] Không hard-code secret.
- [ ] Commit message theo Conventional Commits.
- [ ] Đã review lại code 1 lượt.
- [ ] PostgreSQL data persist sau khi xoá Pod.
- [ ] PVC ở trạng thái `Bound`.
- [ ] RBAC readonly không sửa được resource.
- [ ] NetworkPolicy chỉ cho Pod `app` truy cập Pod `db`.
- [ ] Helm chart install được vào namespace mới sạch.
- [ ] Helm chart upgrade được bằng `dev`, `stg`, `prd` values.
