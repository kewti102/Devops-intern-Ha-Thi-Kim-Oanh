# Task: Day 10 — Observability Basics

- **Intern**: `Hà Thị Kim Oanh`
- **Phase / Week / Day**: `Phase 1 / Week 2 / Day 10`
- **Branch**: `phase-1/week-2/day-10-observability`
- **Submitted at**: `2026-07-08 +07`
- **Time spent**: `8h`

## 1. Mục tiêu

Task này nhằm hiểu các khái niệm nền tảng của observability và dựng một monitoring stack nhỏ bằng Docker Compose.

Nội dung chính:

- Phân biệt 3 trụ cột observability: **logs**, **metrics**, **traces**.
- Hiểu mô hình pull-based của Prometheus và push-based như StatsD/OpenTelemetry Collector.
- Hiểu các khái niệm **SLI**, **SLO**, **SLA** và **Error Budget**.
- Dựng stack gồm Prometheus, Grafana, node-exporter và blackbox-exporter.
- Tạo Grafana dashboard hiển thị CPU, memory, disk và HTTP probe metric.
- Viết lý thuyết alert cho web app gồm latency, error rate và saturation.

## 2. Cách chạy

### 2.1. Yêu cầu môi trường

Máy Linux đã cài Docker và Docker Compose plugin:

```bash
docker --version
docker compose version
```

### 2.2. Clone repo và checkout branch

```bash
git clone <repo-url>
cd Devops-intern-Ha-Thi-Kim-Oanh
git checkout phase-1/week-2/day-10-observability
cd phase-1/week-2/day-10-observability
```

### 2.3. Start observability stack

Chạy stack bằng Docker Compose:

```bash
docker compose -f compose.yml up -d
```

Kiểm tra container:

```bash
docker compose -f compose.yml ps
```

Kỳ vọng có 4 service đang chạy:

```text
day10-prometheus
day10-grafana
day10-node-exporter
day10-blackbox-exporter
```

### 2.4. Kiểm tra các endpoint

```bash
curl -I http://localhost:9090
curl -I http://localhost:3000
curl -s http://localhost:9100/metrics | head
curl -s "http://localhost:9115/probe?target=https://example.com&module=http_2xx" | head
```

Các URL cần truy cập:

```text
Prometheus:        http://localhost:9090
Prometheus targets: http://localhost:9090/targets
Grafana:           http://localhost:3000
node-exporter:     http://localhost:9100/metrics
blackbox-exporter: http://localhost:9115
```

### 2.5. Kiểm tra Prometheus targets

Mở:

```text
http://localhost:9090/targets
```

Kỳ vọng các target ở trạng thái `UP`:

```text
prometheus
node-exporter
blackbox-example
```

Có thể test query trong Prometheus:

```promql
up
```

```promql
node_memory_MemAvailable_bytes
```

```promql
probe_success
```

```promql
probe_duration_seconds
```

### 2.6. Cấu hình Grafana

Mở Grafana:

```text
http://localhost:3000
```

Login mặc định:

```text
username: admin
password: admin
```

Sau khi login, đổi password local theo yêu cầu của Grafana.

Add Prometheus data source:

```text
Connections → Data sources → Add data source → Prometheus
```

URL dùng trong Grafana container:

```text
http://prometheus:9090
```

Bấm `Save & test`.

### 2.7. Import dashboard

Dashboard JSON nằm tại:

```text
dashboards/host.json
```

Import trong Grafana:

```text
Dashboards → New → Import → Upload JSON file
```

Khi import, chọn datasource là Prometheus đã tạo.

Dashboard cần có 4 panel:

- CPU usage host.
- Memory usage host.
- Disk free %.
- HTTP probe success / latency.

### 2.8. Validate dashboard JSON

```bash
python3 -m json.tool dashboards/host.json > /tmp/host.pretty.json
echo $?
```

Kết quả `0` nghĩa là JSON hợp lệ.

### 2.9. Stop stack

Dừng container nhưng giữ volume:

```bash
docker compose -f compose.yml down
```

Dừng và xoá luôn volume để reset sạch:

```bash
docker compose -f compose.yml down -v
```

## 3. Kết quả

Kết quả bài làm gồm:
- `screenshots/`: ảnh chứng minh stack chạy và dashboard hoạt động.

## 4. Khó khăn & cách giải quyết

- **Vấn đề 1: Grafana không connect được Prometheus.**  
  Cách fix: trong Grafana container phải dùng URL `http://prometheus:9090`, không dùng `http://localhost:9090`.

- **Vấn đề 2: Prometheus target bị DOWN.**  
  Cách fix: kiểm tra container bằng `docker compose ps`, kiểm tra service name trong `prometheus.yml`, sau đó restart stack bằng `docker compose down && docker compose up -d`.

- **Vấn đề 3: Disk panel không có data.**  
  Cách fix: kiểm tra metric `node_filesystem_avail_bytes` trong Prometheus để xem label `mountpoint` thực tế là gì, sau đó chỉnh PromQL cho đúng.

- **Vấn đề 4: Dashboard JSON import không đúng datasource.**  
  Cách fix: khi import dashboard, map datasource về Prometheus datasource đã tạo trong Grafana.

- **Vấn đề 5: Grafana mất dashboard sau khi restart.**  
  Cách fix: stack có volume `grafana-data`, nếu chạy `docker compose down -v` thì volume sẽ bị xoá. Cần export dashboard ra `dashboards/host.json` trước khi reset volume.

## 5. Reference

## 6. Self-check

- [ ] Code chạy được trên máy sạch.
- [ ] README có hướng dẫn run lại.
- [ ] Stack chạy được bằng một lệnh `docker compose -f compose.yml up -d`.
- [ ] Prometheus chạy ở port `9090`.
- [ ] Grafana chạy ở port `3000`.
- [ ] node-exporter chạy ở port `9100`.
- [ ] blackbox-exporter chạy ở port `9115`.
- [ ] Prometheus targets đều `UP`.
- [ ] Grafana add được Prometheus data source.
- [ ] Dashboard hiển thị CPU usage host.
- [ ] Dashboard hiển thị memory usage host.
- [ ] Dashboard hiển thị disk free %.
- [ ] Dashboard hiển thị HTTP probe success / latency.
- [ ] Export dashboard JSON vào `dashboards/host.json`.
- [ ] Dashboard JSON import lại được.
- [ ] `notes.md` trả lời đủ 4 câu Part A.
- [ ] `alerts.md` mô tả đủ 3 alert rule.
- [ ] Screenshot/log output nằm trong `screenshots/`.
- [ ] Không hard-code secret.
- [ ] Không commit file local nhạy cảm hoặc file rác.
- [ ] Commit message theo Conventional Commits.
- [ ] Đã review lại code 1 lượt.

