# Task Submission Template

> Mỗi task = 1 thư mục con + 1 PR/MR riêng. Copy template này vào `README.md` của task.

## Task: `Kubernetes Deep Dive — Progress 1: Day 1, Day 2, Day 3 + HPA/VPA`

- **Intern**: `Hà Thị Kim Oanh`
- **Phase / Week / Day**: `Phase 2 / Week 3 / Day 1-3`
- **Branch**: `phase-2/week-3/kubernetes-deep-dive`
- **Submitted at**: `2026-07-09 10:00` (timezone +07)
- **Time spent**: `6 giờ`

## 1. Mục tiêu

Hoàn thành Progress 1 của Kubernetes Deep Dive gồm kiến trúc Kubernetes, kubectl, k3d, Pod, Deployment, Service, Ingress, ConfigMap, Secret và autoscaling bằng HPA/VPA.  
Kết quả cần đạt: tạo được cluster local bằng k3d, deploy app bằng Deployment/Service/Ingress, rolling update/rollback thành công, cấu hình app bằng ConfigMap/Secret, HPA scale được Pod theo CPU load và VPA đưa ra recommendation CPU/memory cho workload.

## 2. Cách chạy

### 2.1. Kiểm tra công cụ

```bash
docker --version
kubectl version --client
k3d version
helm version
```

### 2.2. Tạo k3d cluster

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

### 2.3. Day 1 — First Pod và Service

Tạo Pod nginx:

```bash
kubectl run web --image=nginx --port=80
```

Kiểm tra Pod:

```bash
kubectl get pod web -o wide
kubectl describe pod web
```

Expose Pod bằng Service `ClusterIP`:

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

```text
Pod web ở trạng thái Running.
Service web được tạo thành công.
curl trả về trang HTML mặc định của nginx.
```

### 2.4. Day 2 — Deployment, Service, Rolling Update, Rollback, Ingress

Tạo namespace:

```bash
kubectl create namespace demo --dry-run=client -o yaml | kubectl apply -f -
```

Apply Deployment:

```bash
kubectl apply -f day-2-workloads-ingress/manifests/deployment-v1.yaml
kubectl get deploy,rs,pod -n demo -o wide
```

Apply Service:

```bash
kubectl apply -f day-2-workloads-ingress/manifests/service.yaml
kubectl get svc -n demo
kubectl describe svc demo-app -n demo
```

Rolling update:

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

Rollback:

```bash
kubectl rollout undo deployment/demo-app -n demo
kubectl rollout status deployment/demo-app -n demo
kubectl rollout history deployment/demo-app -n demo
```

Cài ingress-nginx:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.service.type=ClusterIP
```

Kiểm tra ingress-nginx:

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```

Apply Ingress cho `app.local`:

```bash
kubectl apply -f day-2-workloads-ingress/manifests/ingress.yaml
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

```text
Deployment demo-app chạy 3 replicas.
Service demo-app type ClusterIP được tạo.
Rolling update và rollback thành công.
Ingress route app.local hoạt động qua port 8080.
```

### 2.5. Day 2 bổ sung — HPA và VPA

Phần này tích hợp autoscaling vào Progress 1, dùng cùng namespace `demo`.

#### 2.5.1. Cài Metrics Server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Patch cho k3d/k3s local:

```bash
kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[
    {
      "op": "add",
      "path": "/spec/template/spec/containers/0/args/-",
      "value": "--kubelet-insecure-tls"
    }
  ]'
```

Kiểm tra Metrics Server:

```bash
kubectl rollout status deployment/metrics-server -n kube-system
kubectl get apiservices | grep metrics
kubectl top nodes
kubectl top pods -A
```

Kết quả mong đợi:

```text
v1beta1.metrics.k8s.io có status True.
kubectl top nodes hiển thị CPU/MEMORY.
kubectl top pods -A hiển thị CPU/MEMORY của Pod.
```

#### 2.5.2. Tạo Deployment cho HPA

Apply manifest HPA demo app:

```bash
kubectl apply -f day-2-workloads-ingress/autoscaling/demo-app-autoscale.yaml
kubectl rollout status deployment/demo-app-autoscale -n demo
kubectl get deploy,pod,svc -n demo -l app=demo-app-autoscale
```

Yêu cầu quan trọng: container cần có `resources.requests.cpu`, vì HPA tính CPU utilization dựa trên CPU request.

#### 2.5.3. Tạo HPA

```bash
kubectl apply -f day-2-workloads-ingress/autoscaling/demo-app-hpa.yaml
kubectl get hpa -n demo
kubectl describe hpa demo-app-autoscale -n demo
```

Kết quả mong đợi:

```text
HPA demo-app-autoscale được tạo.
minReplicas = 1.
maxReplicas = 5.
CPU target averageUtilization = 50%.
```

#### 2.5.4. Tạo load để kiểm tra HPA scale up

```bash
kubectl apply -f day-2-workloads-ingress/autoscaling/load-generator.yaml
kubectl get pod load-generator -n demo
```

Theo dõi HPA:

```bash
kubectl get hpa -n demo -w
```

Mở terminal khác:

```bash
kubectl get deploy demo-app-autoscale -n demo -w
kubectl top pods -n demo
```

Kết quả mong đợi:

```text
HPA tăng replicas từ 1 lên 2, 3 hoặc cao hơn tuỳ CPU load.
```

Dừng load:

```bash
kubectl delete pod load-generator -n demo
```

Theo dõi scale down:

```bash
kubectl get hpa -n demo -w
```

#### 2.5.5. Cài VPA

Cài VPA từ Kubernetes autoscaler repo:

```bash
cd /tmp

git clone https://github.com/kubernetes/autoscaler.git

cd autoscaler/vertical-pod-autoscaler

./hack/vpa-up.sh
```

Kiểm tra VPA:

```bash
kubectl get pods -n kube-system | grep vpa
kubectl get crd | grep verticalpodautoscalers
```

Kết quả mong đợi có các component:

```text
vpa-admission-controller
vpa-recommender
vpa-updater
```

#### 2.5.6. Tạo Deployment cho VPA

Quay lại folder task:

```bash
cd ~/Devops-intern-Ha-Thi-Kim-Oanh/phase-2/week-3/k8s-progress-1
```

Apply Deployment:

```bash
kubectl apply -f day-2-workloads-ingress/autoscaling/demo-app-vpa-deployment.yaml
kubectl rollout status deployment/demo-app-vpa -n demo
kubectl get deploy,pod -n demo -l app=demo-app-vpa
```

#### 2.5.7. Tạo VPA object

```bash
kubectl apply -f day-2-workloads-ingress/autoscaling/demo-app-vpa.yaml
kubectl get vpa -n demo
kubectl describe vpa demo-app-vpa -n demo
```

VPA dùng update mode `Off`:

```yaml
updatePolicy:
  updateMode: "Off"
```

Mode `Off` nghĩa là VPA chỉ đưa ra recommendation CPU/memory, không tự evict hoặc restart Pod.

Nếu chưa thấy recommendation, chờ thêm vài phút:

```bash
sleep 120
kubectl describe vpa demo-app-vpa -n demo
```

#### 2.5.8. Tạo load nhẹ cho VPA

```bash
kubectl apply -f day-2-workloads-ingress/autoscaling/vpa-load-generator.yaml
```

Sau vài phút:

```bash
kubectl describe vpa demo-app-vpa -n demo
kubectl top pods -n demo
```

Dừng load:

```bash
kubectl delete pod vpa-load-generator -n demo
```

Kết quả mong đợi:

```text
VPA object demo-app-vpa được tạo.
VPA hiển thị recommendation CPU/memory cho container app.
VPA không tự restart Pod vì updateMode là Off.
```

### 2.6. Day 3 — ConfigMap, Secret, Env Injection, Mounted Volume

Apply ConfigMap:

```bash
kubectl apply -f day-3-config-secret/manifests/configmap.yaml
kubectl get configmap demo-config -n demo
kubectl get configmap demo-config -n demo -o yaml
```

Apply Secret:

```bash
kubectl apply -f day-3-config-secret/manifests/secret.yaml
kubectl get secret demo-secret -n demo
```

Deploy Pod demo config:

```bash
kubectl apply -f day-3-config-secret/manifests/config-demo-pod.yaml
kubectl get pod config-demo -n demo
kubectl describe pod config-demo -n demo
```

Test inject biến môi trường:

```bash
kubectl exec -n demo config-demo -- printenv | grep -E "APP_ENV|APP_MESSAGE|DB_USER"
```

Test mount ConfigMap volume:

```bash
kubectl exec -n demo config-demo -- ls -la /etc/demo-config
kubectl exec -n demo config-demo -- cat /etc/demo-config/app.properties
```

Test mount Secret volume:

```bash
kubectl exec -n demo config-demo -- ls -la /etc/demo-secret
kubectl exec -n demo config-demo -- cat /etc/demo-secret/DB_USER
```

Kết quả mong đợi:

```text
ConfigMap demo-config được tạo.
Secret demo-secret được tạo.
Pod config-demo nhận config qua environment variables.
ConfigMap được mount thành file trong /etc/demo-config.
Secret được mount thành file trong /etc/demo-secret.
```

### 2.7. Cleanup

Xoá resource Day 1:

```bash
kubectl delete pod web --ignore-not-found
kubectl delete svc web --ignore-not-found
```

Xoá resource HPA/VPA:

```bash
kubectl delete -f day-2-workloads-ingress/autoscaling/load-generator.yaml --ignore-not-found
kubectl delete -f day-2-workloads-ingress/autoscaling/vpa-load-generator.yaml --ignore-not-found
kubectl delete -f day-2-workloads-ingress/autoscaling/demo-app-hpa.yaml --ignore-not-found
kubectl delete -f day-2-workloads-ingress/autoscaling/demo-app-vpa.yaml --ignore-not-found
kubectl delete -f day-2-workloads-ingress/autoscaling/demo-app-vpa-deployment.yaml --ignore-not-found
kubectl delete -f day-2-workloads-ingress/autoscaling/demo-app-autoscale.yaml --ignore-not-found
```

Xoá namespace:

```bash
kubectl delete namespace demo --ignore-not-found
kubectl delete namespace ingress-nginx --ignore-not-found
```

Xoá VPA components nếu không dùng nữa:

```bash
cd /tmp/autoscaler/vertical-pod-autoscaler
./hack/vpa-down.sh
```

Xoá Metrics Server nếu muốn:

```bash
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Xoá cluster k3d:

```bash
k3d cluster delete dev
```

## 3. Kết quả

- Screenshot / log output kèm trong `./screenshots/`.
- Cluster `dev` được tạo bằng k3d với 1 server node và 2 agent nodes.
- Pod nginx đầu tiên chạy thành công.
- Service `web` được tạo và test được bằng port-forward.
- Deployment `demo-app` chạy 3 replicas.
- Rolling update từ image cũ sang image mới thành công.
- Rollback Deployment thành công.
- ingress-nginx được cài đặt.
- Ingress route `app.local` hoạt động qua port `8080`.
- Metrics Server chạy được và `kubectl top` hiển thị CPU/MEMORY.
- HPA object được tạo cho Deployment `demo-app-autoscale`.
- HPA scale up khi chạy `load-generator`.
- HPA scale down sau khi xoá `load-generator`.
- VPA components được cài đặt.
- VPA object được tạo cho Deployment `demo-app-vpa`.
- VPA hiển thị recommendation CPU/memory ở mode `Off`.
- ConfigMap và Secret được tạo thành công.
- Pod đọc được ConfigMap/Secret qua env injection.
- Pod đọc được ConfigMap/Secret qua mounted volume.

Screenshot minh chứng:

## 4. Khó khăn & cách giải quyết

- **Vấn đề 1: Ingress không truy cập được bằng `app.local`.**  
  Cách fix: kiểm tra ingress-nginx controller đã chạy chưa, kiểm tra `/etc/hosts`, dùng đúng host header `app.local` và port `8080` vì k3d map `8080:80@loadbalancer`.

- **Vấn đề 2: Rolling update không thấy thay đổi rõ ràng.**  
  Cách fix: kiểm tra lại image tag trong Deployment, dùng `kubectl rollout status`, `kubectl rollout history`, `kubectl get rs` và `kubectl get pods --show-labels`.

- **Vấn đề 3: Metrics Server không có metrics hoặc `kubectl top` lỗi.**  
  Cách fix: kiểm tra `kubectl get apiservices | grep metrics`, restart Metrics Server, chờ 1-2 phút; với k3d/k3s local cần patch thêm flag `--kubelet-insecure-tls`.

- **Vấn đề 4: HPA hiện CPU là `<unknown>` hoặc không scale.**  
  Cách fix: đảm bảo container có `resources.requests.cpu`, Metrics Server hoạt động, Pod chạy đủ lâu để có metrics và tạo load liên tục bằng `load-generator`.

- **Vấn đề 5: VPA chưa có recommendation.**  
  Cách fix: kiểm tra `vpa-recommender` đang chạy trong `kube-system`, chờ thêm vài phút, tạo load nhẹ bằng `vpa-load-generator`.

- **Vấn đề 6: Không nên dùng HPA CPU và VPA Auto mode trên cùng một Deployment.**  
  Cách fix: tách workload HPA và VPA thành 2 Deployment riêng; VPA dùng `updateMode: "Off"` để chỉ lấy recommendation.

- **Vấn đề 7: Pod không nhận được ConfigMap hoặc Secret.**  
  Cách fix: kiểm tra namespace `demo`, đúng tên ConfigMap/Secret, đúng key trong `configMapKeyRef` hoặc `secretKeyRef`, sau đó apply lại Pod manifest.

- **Vấn đề 8: Secret có thể bị lộ nếu dùng secret thật.**  
  Cách fix: chỉ dùng demo secret trong lab, không commit token/password production, không chụp hoặc push thông tin nhạy cảm thật.

## 5. Reference

## 6. Self-check

- [ ] Code chạy được trên máy sạch.
- [ ] README có hướng dẫn run lại.
- [ ] Không hard-code secret.
- [ ] Commit message theo Conventional Commits.
- [ ] Đã review lại code 1 lượt.
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
- [ ] Metrics Server chạy thành công.
- [ ] `kubectl top nodes` hoạt động.
- [ ] HPA object được tạo.
- [ ] HPA scale up khi có load.
- [ ] HPA scale down sau khi xoá load.
- [ ] VPA components được cài.
- [ ] VPA object có recommendation.
- [ ] HPA và VPA dùng 2 Deployment riêng để tránh conflict.
- [ ] Day 3 ConfigMap được tạo.
- [ ] Day 3 Secret được tạo.
- [ ] Pod nhận config qua biến môi trường.
- [ ] ConfigMap được mount thành volume.
- [ ] Secret được mount thành volume.
- [ ] Có đầy đủ screenshots.
