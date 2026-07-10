# Task: Phase 2 — Week 3 Kubernetes Deep Dive (Day 1–3)

- **Intern**: `Hà Thị Kim Oanh`
- **Phase / Week / Day**: `Phase 2 / Week 3 / Day 1–3`
- **Branch**: `phase-2/week-3/kubernetes-deep-dive`
- **Submitted at**: `2026-07-09 10:00 +07`
- **Time spent**: `6 giờ`

## 1. Mục tiêu

Bài task này tập trung thực hành các thành phần Kubernetes cơ bản trong Phase 2 — Week 3.

Nội dung đã hoàn thành:

- **Day 1**: Tạo Kubernetes cluster local bằng `k3d`, kiểm tra node, deploy Pod nginx đầu tiên và expose bằng Service `ClusterIP`.
- **Day 2**: Tạo Deployment 3 replicas, Service, thực hành rolling update, rollback và expose app qua Ingress với domain local `app.local`.
- **Day 3**: Sử dụng ConfigMap và Secret để inject cấu hình vào Pod qua environment variables và mounted volume.

## 2. Cách chạy

### 2.1. Yêu cầu môi trường

Máy cần có các công cụ sau:

```bash
docker --version
kubectl version --client
k3d version
helm version
```

### 2.2. Tạo Kubernetes cluster bằng k3d

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

### 2.3. Day 1 — Deploy Pod nginx đầu tiên

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

Kết quả mong đợi: trả về trang HTML mặc định của nginx.

### 2.4. Day 2 — Deployment, Service, Rolling Update, Rollback và Ingress

Tạo namespace:

```bash
kubectl create namespace demo
kubectl config set-context --current --namespace=demo
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

Apply Ingress:

```bash
kubectl apply -f day-2-workloads-ingress/manifests/ingress.yaml
kubectl get ingress -n demo
kubectl describe ingress demo-app -n demo
```

Thêm domain local:

```bash
echo "127.0.0.1 app.local" | sudo tee -a /etc/hosts
```

Test app qua Ingress:

```bash
curl -H "Host: app.local" http://localhost:8080
```

Hoặc mở bằng browser:

```text
http://app.local:8080
```

### 2.5. Day 3 — ConfigMap, Secret và Volume Projection

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

Kiểm tra env injection:

```bash
kubectl exec -n demo config-demo -- printenv | grep -E "APP_ENV|APP_MESSAGE|DB_USER"
```

Kiểm tra ConfigMap mounted volume:

```bash
kubectl exec -n demo config-demo -- ls -la /etc/demo-config
kubectl exec -n demo config-demo -- cat /etc/demo-config/app.properties
```

Kiểm tra Secret mounted volume:

```bash
kubectl exec -n demo config-demo -- ls -la /etc/demo-secret
```

### 2.6. Cleanup

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

## 3. Kết quả

Các kết quả đã hoàn thành:

- Tạo được cluster `dev` bằng k3d với 2 agent nodes.
- `kubectl` kết nối được tới cluster.
- Deploy thành công Pod nginx đầu tiên.
- Expose Pod nginx bằng Service `ClusterIP`.
- Test nginx thành công qua `kubectl port-forward`.
- Tạo được namespace `demo`.
- Deploy `demo-app` bằng Deployment với 3 replicas.
- Tạo được Service `demo-app`.
- Thực hiện rolling update image thành công.
- Thực hiện rollback Deployment thành công.
- Cài được ingress-nginx controller.
- Tạo được Ingress route `app.local`.
- Truy cập app thành công qua `http://app.local:8080`.
- Tạo được ConfigMap `demo-config`.
- Tạo được Secret `demo-secret`.
- Pod `config-demo` nhận được dữ liệu từ ConfigMap và Secret qua environment variables.
- ConfigMap được mount thành file trong `/etc/demo-config`.
- Secret được mount thành file trong `/etc/demo-secret`.

Screenshot minh chứng nằm trong thư mục:

```text
./screenshots/
```

Các screenshot chính:

```text
screenshots/day1-01-cluster-up.png
screenshots/day1-02-nodes.png
screenshots/day1-03-pods-all-namespaces.png
screenshots/day1-04-first-pod-running.png
screenshots/day1-05-service-clusterip.png
screenshots/day1-06-curl-nginx-port-forward.png

screenshots/day2-01-deployment-v1-3-replicas.png
screenshots/day2-02-service.png
screenshots/day2-03-rollout-status-v2.png
screenshots/day2-04-rollout-history.png
screenshots/day2-05-rollback-success.png
screenshots/day2-06-ingress-nginx-installed.png
screenshots/day2-07-ingress-resource.png
screenshots/day2-08-app-local-curl.png
screenshots/day2-09-app-local-browser.png

screenshots/day3-01-configmap.png
screenshots/day3-02-secret-created.png
screenshots/day3-03-config-demo-pod-running.png
screenshots/day3-04-env-injection.png
screenshots/day3-05-configmap-mounted-volume.png
screenshots/day3-06-secret-mounted-volume.png
```

## 4. Khó khăn & cách giải quyết

- **Vấn đề 1: Ingress không truy cập được bằng `app.local`.**  
  Cách fix: kiểm tra lại file `/etc/hosts` có dòng `127.0.0.1 app.local`, kiểm tra k3d đã map port `8080:80@loadbalancer`, sau đó test lại bằng `curl -H "Host: app.local" http://localhost:8080`.

- **Vấn đề 2: ingress-nginx có thể conflict với Traefik mặc định của k3s.**  
  Cách fix: khi tạo cluster k3d, thêm option `--k3s-arg "--disable=traefik@server:0"` để tắt Traefik mặc định.

- **Vấn đề 3: Rolling update hoặc rollback không thấy thay đổi rõ ràng.**  
  Cách fix: kiểm tra bằng `kubectl rollout history deployment/demo-app -n demo`, `kubectl get rs -n demo` và `kubectl get pods -n demo --show-labels`.

- **Vấn đề 4: Secret chứa dữ liệu nhạy cảm.**  
  Cách fix: chỉ dùng giá trị demo trong lab, không commit password thật, token thật hoặc kubeconfig lên Git.

## 5. Reference

- Kubernetes Documentation — Concepts: https://kubernetes.io/docs/concepts/
- Kubernetes Documentation — Pods: https://kubernetes.io/docs/concepts/workloads/pods/
- Kubernetes Documentation — Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Kubernetes Documentation — Services: https://kubernetes.io/docs/concepts/services-networking/service/
- Kubernetes Documentation — Ingress: https://kubernetes.io/docs/concepts/services-networking/ingress/
- Kubernetes Documentation — ConfigMaps: https://kubernetes.io/docs/concepts/configuration/configmap/
- Kubernetes Documentation — Secrets: https://kubernetes.io/docs/concepts/configuration/secret/
- k3d Documentation: https://k3d.io/
- ingress-nginx Documentation: https://kubernetes.github.io/ingress-nginx/
- Helm Documentation: https://helm.sh/docs/

## 6. Self-check

- [x] Code chạy được trên máy sạch.
- [x] README có hướng dẫn run lại.
- [x] Không hard-code secret thật.
- [x] Không commit kubeconfig, private key, token hoặc secret production.
- [x] Cluster k3d `dev` tạo thành công.
- [x] Cluster có 2 agent nodes.
- [x] Day 1 nginx Pod chạy thành công.
- [x] Day 1 Service `ClusterIP` được tạo.
- [x] Day 1 curl qua port-forward thành công.
- [x] Day 2 Deployment có 3 replicas.
- [x] Day 2 Service được tạo.
- [x] Day 2 rolling update thành công.
- [x] Day 2 rollback thành công.
- [x] ingress-nginx được cài đặt.
- [x] `app.local` truy cập được qua Ingress.
- [x] Day 3 ConfigMap được tạo.
- [x] Day 3 Secret được tạo.
- [x] Pod nhận config qua biến môi trường.
- [x] ConfigMap được mount thành volume.
- [x] Secret được mount thành volume.
- [x] Screenshot minh chứng nằm trong `./screenshots/`.
- [x] Commit message theo Conventional Commits.
- [x] Đã review lại code 1 lượt.
