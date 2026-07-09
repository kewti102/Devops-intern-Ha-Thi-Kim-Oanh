cat > notes.md <<'EOF'
# Week 3 — Kubernetes Deep Dive Notes

## Day 1 — Kubernetes Architecture

### Control plane

Control plane là phần điều khiển cluster. Nó quyết định trạng thái mong muốn của cluster và điều phối workload xuống các node.

Các thành phần quan trọng:

- kube-apiserver: cổng giao tiếp chính của Kubernetes API.
- etcd: key-value store lưu trạng thái cluster.
- kube-scheduler: chọn node phù hợp để chạy Pod.
- kube-controller-manager: chạy các controller để reconcile trạng thái thực tế về trạng thái mong muốn.

### Node

Node là máy chạy workload. Trong lab k3d, node là Docker container chạy k3s.

### kubelet

kubelet chạy trên mỗi node, nhận lệnh từ API server và đảm bảo Pod/container chạy đúng như spec.

### kube-proxy

kube-proxy xử lý networking cho Service, giúp traffic tới Service được route tới Pod backend phù hợp.

### CNI

CNI là plugin mạng cho Kubernetes, giúp Pod có network và giao tiếp với nhau.

### Pod

Pod là đơn vị nhỏ nhất có thể deploy trong Kubernetes. Một Pod có thể chứa một hoặc nhiều container.

### Service

Service tạo endpoint ổn định để truy cập Pod. Pod có thể bị xoá/tạo lại, IP Pod thay đổi, nhưng Service giúp client truy cập ổn định.
EOF
