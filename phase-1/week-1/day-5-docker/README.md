# Task: Day 5 - Docker

* **Intern**: Hà Thị Kim Oanh
* **Phase / Week / Day**: Phase 1 / Week 1 / Day 5
* **Branch**: phase-1/week-1/day-5-docker
* **Submitted at**: 2026-06-24 23:59 (+07)
* **Time spent**: 10 giờ

## 1. Mục tiêu

Thực hành các kiến thức cơ bản về Docker, bao gồm Docker Image, Layer, Dockerfile, Docker Network, Docker Volume và Docker Registry.

Dockerize một ứng dụng Node.js bằng Multi-stage Build, chạy bằng non-root user, cấu hình HEALTHCHECK, push image lên Docker Hub và thực hiện scan bảo mật image.

## 2. Cách chạy

### Tạo thư mục day-5-socker

```bash
mkdir -p phase-1/week-1/day-5-docker
cd phase-1/week-1/day-5-docker
```

### Build image

```bash
docker build -t demo-app:1.0.0 .
```

### Chạy ứng dụng

```bash
docker run --rm -p 3000:3000 -e NAME=phase1 demo-app:1.0.0
```

### Kiểm tra API

```bash
curl localhost:3000
```

Kết quả mẫu:

```json
{
  "msg": "hello from phase1",
  "ts": 123456789
}
```

### Kiểm tra Health Check

```bash
docker ps
```

Trạng thái mong đợi:

```text
STATUS: Up (healthy)
```

### Docker Network

Tạo network:

```bash
docker network create demo-net
```

Khởi chạy app1:

```bash
docker run -d \
--name app1 \
--network demo-net \
-e NAME=app1 \
demo-app:1.0.0
```

Khởi chạy app2:

```bash
docker run -d \
--name app2 \
--network demo-net \
-e NAME=app2 \
demo-app:1.0.0
```

Kiểm tra kết nối:

```bash
docker exec app1 wget -qO- http://app2:3000
```

### Docker Volume

Khởi chạy PostgreSQL:

```bash
docker run -d \
--name postgres-demo \
-e POSTGRES_PASSWORD=123456 \
-v pgdata:/var/lib/postgresql/data \
postgres:16-alpine
```

Kiểm tra dữ liệu sau khi restart container:

```bash
docker restart postgres-demo
```

### Bind Mount

```bash
docker run -d \
--name nginx-bind \
-p 8081:80 \
-v $(pwd)/site:/usr/share/nginx/html \
nginx:1.27-alpine
```

Truy cập:

```text
http://localhost:8081
```

### Scan bảo mật

```bash
trivy image demo-app:1.0.0
```
## 3. Kết quả

### Docker Image Analysis

Kết quả phân tích các layer của image bằng `docker history` được lưu tại:

```text
screenshots/docker_history_nginx.png
```

Kết quả phân tích chi tiết image bằng `dive` được lưu tại:

```text
screenshots/dive_nginx.png
```

### Docker Build

Kết quả build image `demo-app:1.0.0` thành công được lưu tại:

```text
screenshots/build_success.png
```

Kích thước image sau khi build được lưu tại:

```text
screenshots/image_size.png
```

### Docker Healthcheck

Kết quả container ở trạng thái `healthy` được lưu tại:

```text
screenshots/healthcheck_pass.png
```

### Docker Network

Kết quả tạo network `demo-net` được lưu tại:

```text
screenshots/network_create.png
```

Kết quả app1 giao tiếp thành công với app2 thông qua Docker DNS được lưu tại:

```text
screenshots/network_app1_app2.png
```

### Docker Volume

Kết quả tạo database trong PostgreSQL được lưu tại:

```text
screenshots/postgres_create_db.png
```

Kết quả dữ liệu vẫn tồn tại sau khi restart container được lưu tại:

```text
screenshots/postgres_persist_after_restart.png
```

### Bind Mount

Kết quả trước khi chỉnh sửa file website được lưu tại:

```text
screenshots/bind_mount_before.png
```

Kết quả sau khi chỉnh sửa file website được lưu tại:

```text
screenshots/bind_mount_after.png
```

### Docker Hub

Kết quả push image lên Docker Hub thành công được lưu tại:

```text
screenshots/dockerhub_push_success.png
```

### Security Scan

Kết quả scan bảo mật image bằng Trivy được lưu tại:

```text
screenshots/trivy_scan.png
```

## 4. Khó khăn & cách giải quyết

### Vấn đề 1: Lỗi quyền Docker

Khi chạy các lệnh Docker gặp lỗi:

```text
permission denied while trying to connect to the docker API
```
-> Cài đặt lại Docker Engine, Thêm user vào nhóm `docker`

### Vấn đề 2: Dive không đọc được image

Lỗi: 
```text
could not find blobs/sha256/... in parsed layers
```
Do phiên bản Dive 0.12.1 chưa tương thích với Docker Engine cài bản snap - 29.1.3 -> cài docker bản DockerCE - 29.6.3 và cài dive bản 0.13.
### Vấn đề 4: Xung đột cổng

Lỗi:

```text
port is already allocated
```
-> Kiểm tra container đang chạy bằng `docker ps`, dừng container cũ hoặc đổi cổng khác.

## 5. Reference
## 6. Self-check

* [x] Code chạy được trên máy sạch.
* [x] README có hướng dẫn run lại.
* [x] Không hard-code secret.
* [x] Commit message theo Conventional Commits.
* [x] Đã review lại code 1 lượt.
