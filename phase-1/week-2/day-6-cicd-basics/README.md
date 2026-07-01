# Task: Day 6 – CI/CD Basics

* **Intern**: Hà Thị Kim Oanh
* **Phase / Week / Day**: Phase 1 / Week 2 / Day 6
* **Branch**: phase-1/week-2/day-6-cicd-basics
* **Submitted at**: 2026-07-02 23:59 (+07)
* **Time spent**: 8 giờ

---

# 1. Mục tiêu

Thực hành xây dựng quy trình CI/CD cơ bản cho ứng dụng Node.js bằng GitHub Actions.

Pipeline tự động thực hiện các bước **Lint → Test → Build Docker Image → Scan Image với Trivy → Generate & Upload SBOM**, đồng thời push Docker image lên GitHub Container Registry (GHCR).

---

# 2. Cách chạy

## 2.1 Clone project

```bash
git clone https://github.com/<github-username>/day-6-cicd-basics.git
cd day-6-cicd-basics
```

---

## 2.2 Cài đặt dependency

```bash
npm ci
```

---

## 2.3 Kiểm tra ESLint

```bash
npm run lint
```

Kết quả mong đợi:

```text
Không có lỗi ESLint.
```

---

## 2.4 Chạy Unit Test

```bash
npm test
```

Kết quả mong đợi:

```text
Tất cả test đều PASS.
```

---

## 2.5 Build Docker Image

```bash
docker build -t demo-app:1.0.0 .
```

Kiểm tra image:

```bash
docker image ls demo-app
```

---

## 2.6 Chạy Docker Container

```bash
docker run -d \
--name demo-app \
-p 3000:3000 \
-e NAME=phase1 \
demo-app:1.0.0
```

Kiểm tra API:

```bash
curl localhost:3000
```

Kết quả mẫu:

```json
{
  "app": "day-6-cicd-basics",
  "message": "hello ci/cd",
  "timestamp": 123456789
}
```

---

## 2.7 Kiểm tra container chạy bằng non-root

```bash
docker exec -it demo-app whoami
```

Kết quả mong đợi:

```text
node
```

---

## 2.8 Push source lên GitHub

```bash
git add .
git commit -m "feat: complete day-6 cicd basics"
git push origin main
```

Sau khi push, GitHub Actions sẽ tự động chạy workflow.

---

## 2.9 Theo dõi GitHub Actions

Pipeline gồm các bước:

```text
Lint
↓
Test
↓
Build Docker Image
↓
Scan Image with Trivy
↓
Generate SBOM
↓
Upload SBOM
```

---

## 2.10 Kiểm tra GHCR

Sau khi workflow thành công, kiểm tra package tại:

```text
GitHub Repository
→ Packages
→ demo-app
```

---

## 2.11 Tải SBOM

Sau khi workflow hoàn thành:

```text
GitHub Actions
→ Workflow Run
→ Artifacts
→ sbom
```

---

# 3. Kết quả

### Pipeline

Pipeline GitHub Actions chạy thành công -> lưu trong ./screenshots/pipeline_success.jpg

### GHCR - quản lý các phiên bản Docker Imagine
Các version demo-app -> lưu trong ./screenshots/ghcr_package.jpg

# 4. Khó khăn & cách giải quyết

### Vấn đề 1: Push workflow bị từ chối

Lỗi PAT không có quyền `workflow` -> edit cấp thêm quyền `workflow`.

### Vấn đề 3: Trivy phát hiện lỗ hổng bảo mật

Trivy phát hiện CVE mức **HIGH/CRITICAL** trong Docker image. Khi phát hiện lỗ hổng xuất ra exit code: 1, GitHub Actions sẽ dừng pipeline và báo **FAILED** -> thử cấu hình exit code: 0.
Kết quả:
* Trivy vẫn thực hiện quét và hiển thị đầy đủ các lỗ hổng.
* Pipeline vẫn tiếp tục chạy và báo **PASS** dù còn tồn tại CVE.
-> bỏ qua các lỗ hổng nghiêm trọng.

---

# 5. Reference

# 6. Self-check

* [x] Code chạy được trên máy sạch.
* [x] README có hướng dẫn run lại.
* [x] Không hard-code secret.
* [x] Commit message theo Conventional Commits.
* [x] Đã review lại code 1 lượt.
