# Day 2 — Linux Advanced

* **Task:** Day 2 — Linux Advanced: Process, systemd, Permission, Networking
* **Intern:** Hà Thị Kim Oanh
* **Phase / Week / Day:** Phase 1 / Week 1 / Day 2
* **Branch:** `phase-1/week-1/day-2-linux-advanced`
* **Submitted at:** 2026-06-18 17:00 (timezone +07)
* **Time spent:** 5 hours

## 1. Mục tiêu

Task này giúp thực hành các kiến thức Linux nâng cao gồm quản lý process, signal, foreground/background process, `nohup`, `disown`, `setsid` và zombie process.

Ngoài ra task yêu cầu:
- viết systemd service để daemonize web app
- thực hành permission nâng cao với setgid, ACL
- kiểm tra service auto-restart và log bằng `journalctl`.
- monitoring script

## 2. Cách chạy

### Bước 1: Di chuyển vào thư mục task

```bash
cd phase-1/week-1/day-2-linux-advanced
```

### Bước 2: Chạy lab process và signal

```bash
chmod +x lab-process.sh
./lab-process.sh
```

### Bước 3: Chuẩn bị thư mục web app

```bash
sudo mkdir -p /opt/webapp
sudo chown -R "$USER:$USER" /opt/webapp
echo "Day 2 Linux Advanced Webapp" > /opt/webapp/index.html
```

### Bước 4: Cài và chạy systemd service cho webapp

```bash
sudo cp webapp.service /etc/systemd/system/webapp.service
sudo systemctl daemon-reload
sudo systemctl enable --now webapp
systemctl status webapp --no-pager
curl http://localhost:8080
```

### Bước 5: Test auto-restart cho webapp service

```bash
sudo kill -9 $(systemctl show -p MainPID --value webapp)
sleep 5
systemctl status webapp --no-pager
journalctl -u webapp -n 30 --no-pager
```

### Bước 6: Tạo group và thư mục shared lab

```bash
sudo groupadd devops 2>/dev/null || true
sudo usermod -aG devops "$USER"
sudo mkdir -p /tmp/shared-lab
sudo chgrp devops /tmp/shared-lab
sudo chmod 2770 /tmp/shared-lab
```

### Bước 7: Cấu hình quyền group và setgid cho thư mục shared lab

```bash
sudo setfacl -m g:devops:rwx /tmp/shared-lab
sudo setfacl -d -m g:devops:rwx /tmp/shared-lab
touch /tmp/shared-lab/group-test.txt
```

### Bước 8: Tạo file secret chỉ owner đọc được

```bash
echo "top secret" > /tmp/shared-lab/secret.txt
chmod 400 /tmp/shared-lab/secret.txt
```

### Bước 9: Cấu hình ACL cho user khác chỉ đọc, không ghi

```bash
sudo useradd -m reviewer 2>/dev/null || true
echo "read only file for reviewer" > /tmp/shared-lab/public.txt
chmod 660 /tmp/shared-lab/public.txt
sudo setfacl -m u:reviewer:rx /tmp/shared-lab
sudo setfacl -m u:reviewer:r-- /tmp/shared-lab/public.txt
```

### Bước 10: Kiểm tra ACL và permission

```bash
getfacl /tmp/shared-lab
getfacl /tmp/shared-lab/public.txt
getfacl /tmp/shared-lab/secret.txt
sudo -u reviewer cat /tmp/shared-lab/public.txt
sudo -u reviewer bash -c 'echo "try write" >> /tmp/shared-lab/public.txt'
```

### Bước 11: Cài và chạy monitor service

```bash
chmod +x monitor.sh
sudo cp monitor.service /etc/systemd/system/monitor.service
sudo systemctl daemon-reload
sudo systemctl enable --now monitor
systemctl status monitor --no-pager
journalctl -u monitor -n 30 --no-pager
```

### Bước 12: Stress test để kiểm tra monitor log

```bash
touch ~/monitor.log
stress-ng --cpu $(nproc) --cpu-method matrixprod --timeout 70s
cat ~/monitor.log
```

## 3. Kết quả

Screenshot / log output (kèm trong ./screenshots/).

Link demo: https://github.com/kewti102/Devops-intern-Ha-Thi-Kim-Oanh/tree/main/phase-1/week-1/day-2-linux-advanced

## 4. Khó khăn & cách giải quyết

1. Các lệnh viết sai cú pháp → đã sửa đúng cú pháp.

2. File `monitor.log` chưa tồn tại khi chạy `tail -f ~/monitor.log` → chạy test đủ lâu để monitor ghi cảnh báo CPU.

## 5. Reference

- Perplexity
- Chatgpt

## 6. Self-check

* ✅ systemd service webapp chạy được, auto-restart sau khi kill.
* ✅ ACL trên /tmp/shared-lab đúng yêu cầu (kèm output getfacl).
* ✅ monitor.sh log đúng khi stress test.
* ✅ Trả lời được 5 câu Part A đúng ý.
