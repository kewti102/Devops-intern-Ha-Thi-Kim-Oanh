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

## Clone repository

```bash
git clone https://github.com/kewti102/day-6-cicd-basics.git
cd day-6-cicd-basics
```
## Cài đặt thư viện

```bash
npm install
```
## Kiểm tra cú pháp

```bash
npm run lint
```
## Chạy unit test

```bash
npm test
```
## Chạy ứng dụng

```bash
npm start
```
## Build Docker Image

```bash
docker build -t demo-app .
``
## Chạy Docker Container

```bash
docker run -d -p 3000:3000 demo-app
```
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
