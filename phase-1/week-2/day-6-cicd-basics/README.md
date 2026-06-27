# Task: `day-6-cicd-basics`

* **Intern**: Hà Thị Kim Oanh
* **Phase / Week / Day**: Phase 1 / Week 2 / Day 6
* **Branch**: `main`
* **Submitted at**: `2026-06-27 23:59` (GMT+7)
* **Time spent**: `6 giờ`

---

# 1. Mục tiêu

Tìm hiểu quy trình CI/CD cơ bản và xây dựng pipeline bằng GitHub Actions cho một ứng dụng Node.js. Pipeline bao gồm các bước lint, test, build Docker image và push image lên GitHub Container Registry (GHCR).

---
# 2. Cách chạy

# Part B - Xây dựng pipeline CI/CD cho ứng dụng demo

## Bước 1. Tạo thư mục dự án

```bash
mkdir day-6-cicd-basics
cd day-6-cicd-basics
```

Khởi tạo dự án Node.js:

```bash
npm init -y
```

---

## Bước 2. Cài đặt các thư viện cần thiết

Cài đặt Express:

```bash
npm install express
```

Cài đặt ESLint:

```bash
npm install --save-dev eslint
```

---

## Bước 3. Tạo cấu trúc thư mục

```text
day-6-cicd-basics/
├── app/
│   └── server.js
├── test/
│   └── math.test.js
├── .github/
│   └── workflows/
│       └── ci.yml
├── Dockerfile
├── .dockerignore
├── package.json
└── package-lock.json
```

---

## Bước 4. Cập nhật package.json

Thêm các script:

```json
"scripts": {
  "start": "node app/server.js",
  "lint": "node --check app/server.js",
  "test": "node --test"
}
```

---

## Bước 5. Kiểm tra ứng dụng trên máy cục bộ

Kiểm tra cú pháp:

```bash
npm run lint
```

Chạy unit test:

```bash
npm test
```

Khởi động ứng dụng:

```bash
npm start
```

Mở trình duyệt:

```
http://localhost:3000
```

---

## Bước 6. Tạo Dockerfile

Build Docker Image:

```bash
docker build -t demo-app .
```

Kiểm tra image:

```bash
docker images
```

Chạy container:

```bash
docker run -d -p 3000:3000 demo-app
```

Kiểm tra container đang chạy:

```bash
docker ps
```

---

## Bước 7. Tạo file .dockerignore

Thêm các thư mục không cần đưa vào Docker Build Context:

```text
node_modules
.git
.github
npm-debug.log
```

---

## Bước 8. Tạo GitHub Actions Workflow

Tạo thư mục:

```bash
mkdir -p .github/workflows
```

Tạo file:

```text
.github/workflows/ci.yml
```

Workflow gồm các job:

* Lint
* Test
* Build Docker Image
* Push Docker Image lên GitHub Container Registry (GHCR)

Workflow được kích hoạt khi:

* Push lên nhánh `main`
* Tạo Pull Request vào nhánh `main`

---

## Bước 9. Đưa project lên GitHub

Khởi tạo Git (nếu chưa có):

```bash
git init
```

Thêm toàn bộ file:

```bash
git add .
```

Commit:

```bash
git commit -m "feat: implement CI/CD pipeline"
```

Push lên GitHub:

```bash
git push origin main
```

---

## Bước 10. Kiểm tra GitHub Actions

Vào repository trên GitHub:

```
Actions
```

Kiểm tra các job:

* Lint
* Test
* Build Docker Image

Đảm bảo tất cả đều hoàn thành thành công.

---

## Bước 11. Kiểm tra Docker Image trên GHCR

Sau khi workflow hoàn thành:

* Mở repository trên GitHub.
* Chọn **Packages**.
* Kiểm tra package `demo-app`.
* Xác nhận image đã được push thành công với các tag:

```
latest
sha-<short_sha>
```

---

## Bước 12. Kiểm tra Cache

Mở workflow vừa chạy:

```
Actions
→ CI/CD Pipeline
→ Lint hoặc Test
```

Tại bước **Setup Node.js**, kiểm tra cache npm đã được sử dụng để tăng tốc các lần chạy tiếp theo.
# 3. Kết quả
* Pipeline GitHub Actions chạy thành công → kết quả được lưu trong `screenshots/pipeline.png`.
* Docker image được build và push thành công lên GitHub Container Registry (GHCR) → kết quả được lưu trong `screenshots/package.png`.
* Cache npm hoạt động trong GitHub Actions → kết quả được lưu trong `screenshots/run_number.png`.
---
# 4. Khó khăn & cách giải quyết

### Vấn đề 1

Phiên bản Node.js trên máy cục bộ quá cũ (Node.js 12), không tương thích với ESLint và các package hiện tại -> nâng cấp lên Node.js 20 và cài đặt lại toàn bộ dependencies bằng `npm install`.

### Vấn đề 2

GitHub Actions gặp lỗi khi sử dụng Trivy Action ở phần Bonus. ->  Hoàn thành các bước bắt buộc của pipeline (lint, test, build, push image). Phần Trivy và SBOM là Bonus nên được tách riêng để xử lý sau.

### Vấn đề 3

Ban đầu push workflow lên GitHub bị từ chối do Personal Access Token chưa có quyền cập nhật GitHub Actions -> Cấu hình lại quyền truy cập repository và sử dụng `GITHUB_TOKEN` để xác thực khi push Docker image lên GHCR.

# 5. Reference
Link repo: https://github.com/kewti102/day-6-cicd-basics.git
Link imagine: ./screenshots.
# 6. Self-check
* [x] Code chạy được trên máy sạch.
* [x] README có hướng dẫn chạy lại.
* [x] Không hard-code secret.
* [x] Commit message theo Conventional Commits.
* [x] Đã review lại code một lượt.
