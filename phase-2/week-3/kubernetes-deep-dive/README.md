# Phase 2 — Week 3: Kubernetes Deep Dive

- **Thực tập sinh**: `Hà Thị Kim Oanh`
- **Phase / Week**: `Phase 2 / Week 3`
- **Branch**: `phase-2/week-3/kubernetes-deep-dive`
- **Nền tảng lab**: `k3d local cluster`
- **Tên cluster**: `dev`
- **Thời gian nộp**: `2026-07-09 10:00> +07`
- **Thời gian thực hiện**: `6`

## 1. Tổng quan

Bài nộp này bao gồm **Day 1, Day 2 và Day 3** của Phase 2 — Week 3 Kubernetes Deep Dive.

Nội dung chính:

- **Day 1**: Kiến trúc Kubernetes, kubectl, cài và tạo cluster bằng k3d, deploy Pod đầu tiên và tạo Service.
- **Day 2**: Deployment, Service, rolling update, rollback và Ingress.
- **Day 3**: ConfigMap, Secret, inject biến môi trường và mount volume từ ConfigMap/Secret.

## 2. Cấu trúc thư mục

```text
phase-2/week-3/kubernetes-deep-dive/
├── README.md
├── notes.md
├── day-1-first-cluster/
│   └── manifests/
├── day-2-workloads-ingress/
│   └── manifests/
├── day-3-config-secret/
│   └── manifests/
└── screenshots/
```

## 3. Công cụ cần có

Kiểm tra các công cụ cần thiết:

```bash
docker --version
kubectl version --client
k3d version
helm version
```

Lab này sử dụng Kubernetes cluster local được tạo bằng `k3d`.

---

## 4. Day 1 — First Cluster

### 4.1. Mục tiêu

Mục tiêu của Day 1 là hiểu kiến trúc cơ bản của Kubernetes và deploy workload đầu tiên.

Các khái niệm chính:

- Control plane.
- Worker node.
- kubelet.
- kube-proxy.
- CNI.
- Pod.
- Service.
- kubectl.

### 4.2. Tạo k3d cluster

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
kubectl get pods -A
```

Kết quả mong đợi:

- Cluster `dev` được tạo thành công.
- Cluster có 1 server node và 2 agent nodes.
- `kubectl` kết nối được tới cluster.

### 4.3. Deploy Pod đầu tiên

Tạo Pod nginx:

```bash
kubectl run web --image=nginx --port=80
```

Kiểm tra Pod:

```bash
kubectl get pod web -o wide
kubectl describe pod web
```

Expose Pod bằng Service loại ClusterIP:

```bash
kubectl expose pod web --type=ClusterIP --port=80 --target-port=80
```

Kiểm tra Service:

```bash
kubectl get svc
kubectl describe svc web
```

Test bằng port-forward:

```bash
kubectl port-forward svc/web 8081:80
```

Mở terminal khác và chạy:

```bash
curl http://localhost:8081
```

Kết quả mong đợi:

- Pod `web` ở trạng thái `Running`.
- Service `web` được tạo thành công.
- Lệnh `curl` trả về trang HTML mặc định của nginx.

### 4.4. Screenshot Day 1

Các ảnh minh chứng:

```text
screenshots/day1-01-cluster-up.png
screenshots/day1-02-nodes.png
screenshots/day1-03-pods-all-namespaces.png
screenshots/day1-04-first-pod-running.png
screenshots/day1-05-service-clusterip.png
screenshots/day1-06-curl-nginx-port-forward.png
```

---

## 5. Day 2 — Deployment, Service và Ingress

### 5.1. Mục tiêu

Mục tiêu của Day 2 là thực hành các workload primitives và expose app ra ngoài bằng Ingress.

Các khái niệm chính:

- Deployment.
- ReplicaSet.
- Service.
- Rolling update.
- Rollback.
- Ingress.
- ingress-nginx.
- Custom domain local thông qua `/etc/hosts`.

### 5.2. Tạo namespace

```bash
kubectl create namespace demo
kubectl config set-context --current --namespace=demo
```

### 5.3. Tạo Deployment

Apply Deployment manifest:

```bash
kubectl apply -f day-2-workloads-ingress/manifests/deployment-v1.yaml
```

Kiểm tra resource:

```bash
kubectl get deploy,rs,pod -n demo -o wide
```

Kết quả mong đợi:

- Deployment `demo-app` được tạo.
- Deployment chạy 3 replicas.
- Tất cả Pod ở trạng thái `Running`.

### 5.4. Tạo Service

Apply Service manifest:

```bash
kubectl apply -f day-2-workloads-ingress/manifests/service.yaml
```

Kiểm tra Service:

```bash
kubectl get svc -n demo
kubectl describe svc demo-app -n demo
```

Kết quả mong đợi:

- Service `demo-app` được tạo.
- Service có type là `ClusterIP`.
- Service forward traffic tới các Pod có label `app=demo-app`.

### 5.5. Rolling update

Update image:

```bash
kubectl set image deployment/demo-app nginx=nginx:1.26 -n demo
kubectl rollout status deployment/demo-app -n demo
kubectl rollout history deployment/demo-app -n demo
```

Kiểm tra ReplicaSet và Pod:

```bash
kubectl get rs -n demo
kubectl get pods -n demo -o wide --show-labels
```

Kết quả mong đợi:

- Rolling update hoàn tất thành công.
- ReplicaSet mới được tạo.
- Các Pod được cập nhật sang image mới.

### 5.6. Rollback

Rollback về revision trước:

```bash
kubectl rollout undo deployment/demo-app -n demo
kubectl rollout status deployment/demo-app -n demo
kubectl rollout history deployment/demo-app -n demo
```

Kết quả mong đợi:

- Deployment rollback thành công.
- ReplicaSet cũ hoạt động lại.

### 5.7. Cài ingress-nginx

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create namespace ingress-nginx

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.service.type=ClusterIP
```

Kiểm tra ingress-nginx:

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```

Kết quả mong đợi:

- ingress-nginx controller chạy thành công.
- Service của ingress controller được tạo.

### 5.8. Tạo Ingress cho app.local

Apply Ingress manifest:

```bash
kubectl apply -f day-2-workloads-ingress/manifests/ingress.yaml
```

Kiểm tra Ingress:

```bash
kubectl get ingress -n demo
kubectl describe ingress demo-app -n demo
```

Thêm domain local vào `/etc/hosts`:

```bash
echo "127.0.0.1 app.local" | sudo tee -a /etc/hosts
```

Test app qua Ingress:

```bash
curl -H "Host: app.local" http://localhost:8080
```

Hoặc mở browser:

```text
http://app.local:8080
```

Kết quả mong đợi:

- Ingress route `app.local` hoạt động.
- App truy cập được thông qua port `8080` của k3d load balancer.

### 5.9. Screenshot Day 2

Các ảnh minh chứng:

```text
screenshots/day2-01-deployment-v1-3-replicas.png
screenshots/day2-02-service.png
screenshots/day2-03-rollout-status-v2.png
screenshots/day2-04-rollout-history.png
screenshots/day2-05-rollback-success.png
screenshots/day2-06-ingress-nginx-installed.png
screenshots/day2-07-ingress-resource.png
screenshots/day2-08-app-local-curl.png
screenshots/day2-09-app-local-browser.png
```

---

## 6. Day 3 — ConfigMap, Secret và Volume Projection

### 6.1. Mục tiêu

Mục tiêu của Day 3 là tách cấu hình và dữ liệu nhạy cảm ra khỏi source code của ứng dụng.

Các khái niệm chính:

- ConfigMap.
- Secret.
- Inject biến môi trường.
- Mount ConfigMap thành volume.
- Mount Secret thành volume.
- Projected configuration vào trong Pod.

### 6.2. Apply ConfigMap

```bash
kubectl apply -f day-3-config-secret/manifests/configmap.yaml
```

Kiểm tra ConfigMap:

```bash
kubectl get configmap demo-config -n demo
kubectl get configmap demo-config -n demo -o yaml
```

Kết quả mong đợi:

- ConfigMap `demo-config` được tạo.
- ConfigMap chứa các giá trị cấu hình cho ứng dụng và nội dung file config.

### 6.3. Apply Secret

```bash
kubectl apply -f day-3-config-secret/manifests/secret.yaml
```

Kiểm tra Secret:

```bash
kubectl get secret demo-secret -n demo
```

Kết quả mong đợi:

- Secret `demo-secret` được tạo.
- Secret lưu các giá trị nhạy cảm trong phạm vi lab như username/password database demo.

Lưu ý: Không commit password thật, token thật hoặc secret production lên Git.

### 6.4. Deploy Pod demo config

```bash
kubectl apply -f day-3-config-secret/manifests/config-demo-pod.yaml
```

Kiểm tra Pod:

```bash
kubectl get pod config-demo -n demo
kubectl describe pod config-demo -n demo
```

Kết quả mong đợi:

- Pod `config-demo` ở trạng thái `Running`.
- Pod nhận dữ liệu từ ConfigMap và Secret.

### 6.5. Test inject biến môi trường

```bash
kubectl exec -n demo config-demo -- printenv | grep -E "APP_ENV|APP_MESSAGE|DB_USER"
```

Kết quả mong đợi:

- `APP_ENV` được lấy từ ConfigMap.
- `APP_MESSAGE` được lấy từ ConfigMap.
- `DB_USER` được lấy từ Secret.

### 6.6. Test mount ConfigMap volume

```bash
kubectl exec -n demo config-demo -- ls -la /etc/demo-config
kubectl exec -n demo config-demo -- cat /etc/demo-config/app.properties
```

Kết quả mong đợi:

- ConfigMap được mount thành file trong `/etc/demo-config`.
- File `app.properties` đọc được bên trong Pod.

### 6.7. Test mount Secret volume

```bash
kubectl exec -n demo config-demo -- ls -la /etc/demo-secret
```

Có thể kiểm tra trong lab:

```bash
kubectl exec -n demo config-demo -- cat /etc/demo-secret/DB_USER
```

Kết quả mong đợi:

- Secret được mount thành file trong `/etc/demo-secret`.

### 6.8. Screenshot Day 3

Các ảnh minh chứng:

```text
screenshots/day3-01-configmap.png
screenshots/day3-02-secret-created.png
screenshots/day3-03-config-demo-pod-running.png
screenshots/day3-04-env-injection.png
screenshots/day3-05-configmap-mounted-volume.png
screenshots/day3-06-secret-mounted-volume.png
```

---

## 7. Tóm tắt kiến thức

### 7.1. ConfigMap vs Secret

**ConfigMap** dùng để lưu dữ liệu cấu hình không nhạy cảm, ví dụ environment name, feature flag hoặc message của ứng dụng.

**Secret** dùng để lưu dữ liệu nhạy cảm như password, token hoặc key. Trong môi trường production, Secret cần được quản lý cẩn thận và không nên commit trực tiếp lên Git.

### 7.2. Inject biến môi trường

Kubernetes có thể inject giá trị từ ConfigMap và Secret vào container dưới dạng environment variables. Cách này phù hợp khi ứng dụng đọc cấu hình từ biến môi trường.

### 7.3. Volume projection

Kubernetes cũng có thể mount ConfigMap và Secret thành file bên trong container. Cách này phù hợp khi ứng dụng đọc cấu hình từ file trên disk.

---

## 8. Cleanup

Xoá resource lab:

```bash
kubectl delete pod web --ignore-not-found
kubectl delete svc web --ignore-not-found

kubectl delete namespace demo --ignore-not-found
kubectl delete namespace ingress-nginx --ignore-not-found
```

Xoá cluster k3d:

```bash
k3d cluster delete dev
```

---

## 9. Self-check

- [ ] k3d cluster `dev` chạy thành công.
- [ ] Cluster có 2 agent nodes.
- [ ] Day 1 nginx Pod chạy thành công.
- [ ] Day 1 ClusterIP Service được tạo.
- [ ] Day 1 curl qua port-forward thành công.
- [ ] Day 2 Deployment có 3 replicas.
- [ ] Day 2 Service được tạo.
- [ ] Day 2 rolling update thành công.
- [ ] Day 2 rollback thành công.
- [ ] ingress-nginx được cài đặt.
- [ ] `app.local` truy cập được qua Ingress.
- [ ] Day 3 ConfigMap được tạo.
- [ ] Day 3 Secret được tạo.
- [ ] Pod nhận config qua biến môi trường.
- [ ] ConfigMap được mount thành volume.
- [ ] Secret được mount thành volume.
- [ ] Có đầy đủ screenshots.
- [ ] Không commit kubeconfig, private key, token hoặc secret thật.
