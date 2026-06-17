# Task: Day 1 - Linux Fundamentals

**Intern:** Hà Thị Kim Oanh
**Phase / Week / Day:** Phase 1 / Week 1 / Day 1
**Branch:** phase-1/week-1/day-1-linux
**Submitted at:** 2026-06-17 22:30:00 +07
**Time spent:** 5 giờ

## 1. Mục tiêu

* Thực hành và làm quen với các lệnh Linux thường dùng trong quản trị hệ thống.
* Nắm được cách sử dụng pipe và redirect để xử lý dữ liệu trên command line.
* Viết Bash script thực hiện sao lưu thư mục và xử lý lỗi cơ bản.
* Hiểu các khái niệm về quyền truy cập file, process, biến môi trường và hệ thống tập tin Linux.

## 2. Cách chạy

### Chuẩn bị

Cấp quyền thực thi cho các script:

```bash
chmod +x lab.sh backup.sh
```

### Chạy bài lab

```bash
./lab.sh
```

Script sẽ thực hiện:

* Liệt kê các process sử dụng RAM cao nhất.
* Đếm số lượng file log trong `/var/log`.
* Thống kê địa chỉ IP xuất hiện trong file xác thực.
* Xuất thông tin hệ thống ra file `system-info.txt`.

### Chạy script backup

Hiển thị hướng dẫn sử dụng:

```bash
./backup.sh --help
```

hoặc

```bash
./backup.sh -h
```

Thực hiện sao lưu một thư mục:

```bash
./backup.sh <directory>
```

Ví dụ:

```bash
./backup.sh .
```

## 3. Kết quả

* Hoàn thành file `notes.md` ghi chú các Linux commands đã học.
* Hoàn thành `lab.sh` theo yêu cầu của bài tập.
* Hoàn thành `backup.sh` với chức năng backup và kiểm tra lỗi.
* Các hình ảnh minh họa và kết quả chạy chương trình được lưu trong thư mục `screenshots/`.

## 4. Khó khăn & cách giải quyết

### Vấn đề 1

Trong quá trình thống kê số lượng file log, lệnh `find` trả về thông báo `Permission denied` đối với một số thư mục trong `/var/log`.

**Cách giải quyết:**

Sử dụng redirect lỗi:

```bash
find /var/log -maxdepth 2 -type f -name "*.log" 2>/dev/null
```

để loại bỏ các thông báo không cần thiết và chỉ lấy kết quả phục vụ bài tập.

### Vấn đề 2

Khi push source code lên GitHub, em gặp lỗi:

```text
Updates were rejected because the remote contains work that you do not have locally
```

**Cách giải quyết:**

Đồng bộ lịch sử commit giữa local và remote bằng:

```bash
git pull origin main --allow-unrelated-histories --no-rebase
```

sau đó thực hiện push lại thành công.

## 5. Reference
* Google
* Chatgpt

## 6. Self-check

* [x] Script chạy thành công trên Ubuntu.
* [x] README có hướng dẫn chạy lại.
* [x] Không chứa secret hoặc thông tin nhạy cảm.
* [x] Sử dụng commit message theo Conventional Commits.
* [x] Đã tự kiểm tra lại toàn bộ file trước khi nộp.
* [x] Có đính kèm screenshot minh họa kết quả.
