# Task: Day 7 - CI/CD Advanced
* **Intern**: Hà Thị Kim Oanh
* **Phase / Week / Day**: Phase 1 / Week 2 / Day 7
* **Branch**: `phase-1/week-2/day-7-cicd-advanced`
* **Submitted at**: 2026-07-03 23:59 (+07)
* **Time spent**: 10 giờ
---
# 1. Mục tiêu
Xây dựng CI/CD pipeline nâng cao với GitHub Actions, bao gồm Reusable Workflow, Docker Build & Push lên GitHub Container Registry (GHCR), quét bảo mật bằng Trivy, sinh Software Bill of Materials (SBOM), triển khai nhiều môi trường (Staging/Production), Matrix Strategy và Release tự động.
# 2. Cách chạy
## Part A: Sửa code trong ci.yml để tạo matrix test: chỉ sửa phần test
test:
  name: Test
  strategy:
    fail-fast: false
    matrix:
      node: [18,20,22]
      os:
        - ubuntu-22.04
        - ubuntu-24.04
      exclude:
        - node: 18
          os: ubuntu-24.04
  runs-on: ${{ matrix.os }}
  steps:
    - uses: actions/checkout@v4

    - uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node }}
    ...
## Part B: 
Tách 1 file .github/workflows/reusable-build.yml nhận input image_name + image_tag  -> kết quả ở file reusable-build.yml
## Part C: Tạo file deploy.yml trong đó có 2 stage: 
* deploy-staging chạy ngay khi merge vào main.
* deploy-production chạy khi tag v*.*.*, chờ approval.
* deploy trong deploy workflows
## Part D: 
Tự sinh release note bằng actions/github-script hoặc softprops/action-gh-release
-> Trong file `deploy.yml` viết trigger: 
```YAML
on:
push:
tags:
v*.*.*
```
### Khi tạo tag: 
```
git tag v1.0.0
git push origin v1.0.0
```
### Khi tạo release:
Trong file `deploy.yml` sử dụng `softprops/action-gh-release`
```
- uses: softprops/action-gh-release@v2
```
### Tạo tag có dạng 1.0.0 :
```
tags:
ghcr.io/${{ steps.owner.outputs.value }}/demo-app:${{ github.ref_name }}
```
## Push code
```bash
git add .
git commit -m "feat: complete day 7"
git push origin phase-1/week-2/day-7-cicd-advanced
```
## Kiểm tra GitHub Actions, Docker Image trên GHCR
Vào:
```
GitHub Repository → Actions
GitHub → Packages → demo-app
```
# 3. Kết quả
Outputs được lưu trong:
```
screenshots/
    ├── matrix-runs.png
    ├── deployment_staging.png
    ├── production-approval.png
    └── release-page.png
```
# 4. Khó khăn & cách giải quyết
### VDD1: Chuyển thư mục .github/workflows ra thư mục gốc. 
#### Vấn đề 1.1: Docker Build không tìm thấy đường dẫn Dockerfile
* Repository theo cấu trúc monorepo nên Dockerfile không nằm ở thư mục gốc
 -> Sửa: Chỉ định rõ:
```yaml
context: ./phase-1/week-2/day-7-cicd-advanced
file: ./phase-1/week-2/day-7-cicd-advanced/Dockerfile
```
#### Vấn đề 1.2: GitHub Actions không tìm thấy package-lock.json
Workflow tìm `package-lock.json` ở thư mục gốc.
-> Sửa: Thêm:
```yaml
cache-dependency-path:
phase-1/week-2/day-7-cicd-advanced/package-lock.json
```
và sử dụng:
```yaml
working-directory:
phase-1/week-2/day-7-cicd-advanced
```
---
#### Vấn đề 1.3: Trivy quét image thất bại
Lỗi: ``` No such image ```
Docker Image chưa được push lên GHCR.
-> Sửa: Đổi: Trong file reusable-build.yml
```yaml
push: false -> true.
```
#### Vấn đề 2: Thêm quyền Write Package cho repo Devops-intern-Ha-Thi-Kim-Oanh.
Lỗi:
```text
permission_denied:
write_package
```
-> Repository chưa được cấp quyền ghi Package.
-> Sửa: 
* Bật **Package Settings -> Manage Actions access -> Add Repository: Devops-intern-Ha-Thi-Kim-Oanh**.
# 6. Self-check
* [x] Code chạy được trên máy sạch.
* [x] README có hướng dẫn run lại.
* [x] Không hard-code secret.
* [x] Commit message theo Conventional Commits.
* [x] Đã review lại code 1 lượt.
