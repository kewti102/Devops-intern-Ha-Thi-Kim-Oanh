# Day 10 — Alert Design

## 1. Mục tiêu

File này mô tả các alert rule nên đặt cho một web app cơ bản, tập trung vào 3 nhóm tín hiệu quan trọng:

- **Latency**: hệ thống phản hồi chậm.
- **Error rate**: tỷ lệ request lỗi tăng cao.
- **Saturation**: tài nguyên hệ thống gần cạn hoặc bị quá tải.

Các alert dưới đây mang tính lý thuyết, chưa cần chạy trong stack Docker Compose của Day 10.

---

## 2. Alert rule cho web app

## Alert 1 — High Latency

### Mục đích

Phát hiện khi người dùng bắt đầu cảm thấy web app phản hồi chậm.

Latency nên theo dõi bằng percentile như P95 hoặc P99 thay vì chỉ dùng average, vì average có thể che mất các request rất chậm.

### Ví dụ rule

```yaml
groups:
  - name: web-app-alerts
    rules:
      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
        for: 10m
        labels:
          severity: warning
          service: web-app
        annotations:
          summary: "Web app P95 latency is higher than 500ms"
          description: "P95 latency has been above 500ms for more than 10 minutes."
```

### Giải thích

- `histogram_quantile(0.95, ...)`: tính P95 latency.
- `rate(...[5m])`: lấy tốc độ tăng của histogram bucket trong 5 phút gần nhất.
- `> 0.5`: alert nếu P95 latency lớn hơn 0.5 giây.
- `for: 10m`: chỉ bắn alert nếu tình trạng kéo dài 10 phút, tránh alert vì spike ngắn.

### Khi nào alert này quan trọng?

Alert này quan trọng khi latency cao kéo dài và ảnh hưởng trực tiếp đến trải nghiệm người dùng. Ví dụ: user phải chờ lâu khi login, checkout hoặc gọi API chính.

---

## Alert 2 — High Error Rate

### Mục đích

Phát hiện khi tỷ lệ request lỗi HTTP 5xx tăng cao.

Error rate là một trong những alert quan trọng nhất vì nó phản ánh trực tiếp việc service đang không phục vụ request thành công.

### Ví dụ rule

```yaml
groups:
  - name: web-app-alerts
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m]))
          /
          sum(rate(http_requests_total[5m]))
          > 0.02
        for: 10m
        labels:
          severity: critical
          service: web-app
        annotations:
          summary: "Web app 5xx error rate is above 2%"
          description: "More than 2% of HTTP requests are returning 5xx errors for 10 minutes."
```

### Giải thích

- `http_requests_total{status=~"5.."}`: đếm các request lỗi server-side như 500, 502, 503, 504.
- Chia số request 5xx cho tổng số request để ra tỷ lệ lỗi.
- `> 0.02`: alert nếu error rate vượt 2%.
- `severity: critical`: lỗi 5xx cao thường ảnh hưởng trực tiếp đến user nên có mức độ nghiêm trọng cao hơn latency warning.

### Khi nào alert này quan trọng?

Alert này quan trọng khi web app có nhiều request thất bại, ví dụ lỗi backend, database down, deploy lỗi hoặc dependency bên ngoài bị lỗi.

---

## Alert 3 — Saturation / Resource Exhaustion

### Mục đích

Phát hiện khi hệ thống gần cạn tài nguyên như CPU, memory hoặc disk.

Saturation không phải lúc nào cũng ảnh hưởng user ngay lập tức, nhưng nó là tín hiệu cảnh báo hệ thống có nguy cơ chậm hoặc lỗi trong thời gian ngắn.

### Ví dụ rule CPU

```yaml
groups:
  - name: host-alerts
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 85
        for: 15m
        labels:
          severity: warning
          service: web-app
        annotations:
          summary: "Host CPU usage is above 85%"
          description: "CPU usage has been above 85% for more than 15 minutes."
```

### Ví dụ rule memory

```yaml
groups:
  - name: host-alerts
    rules:
      - alert: HighMemoryUsage
        expr: 100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) > 90
        for: 15m
        labels:
          severity: warning
          service: web-app
        annotations:
          summary: "Host memory usage is above 90%"
          description: "Memory usage has been above 90% for more than 15 minutes."
```

### Ví dụ rule disk

```yaml
groups:
  - name: host-alerts
    rules:
      - alert: LowDiskFree
        expr: 100 * (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) < 15
        for: 15m
        labels:
          severity: warning
          service: web-app
        annotations:
          summary: "Disk free space is below 15%"
          description: "Root filesystem has less than 15% free disk space for more than 15 minutes."
```

### Giải thích

- CPU cao kéo dài có thể làm request chậm.
- Memory gần cạn có thể gây OOM kill hoặc swap.
- Disk gần đầy có thể làm app không ghi log, database lỗi hoặc deploy thất bại.
- Nên đặt `for` đủ dài để tránh alert do spike ngắn.

### Khi nào alert này quan trọng?

Alert saturation quan trọng khi tài nguyên gần hết và cần hành động như scale up, scale out, cleanup disk, tối ưu query hoặc rollback deploy.

---

## 3. Noise alert vs Actionable alert

## Noise alert là gì?

Noise alert là alert gây nhiễu, không yêu cầu hành động rõ ràng hoặc không phản ánh vấn đề thật sự ảnh hưởng đến user.

### Ví dụ noise alert

- CPU tăng 95% trong 10 giây rồi tự giảm.
- Một request 500 đơn lẻ trong tổng hàng chục nghìn request.
- Alert bắn liên tục nhưng không có user impact.
- Alert không có owner, không có runbook, không biết ai cần xử lý.
- Alert chỉ báo “có gì đó lạ” nhưng không chỉ ra hành động cụ thể.

### Hậu quả của noise alert

- Gây mệt mỏi cho team.
- Làm người trực alert bỏ qua cảnh báo.
- Khi có sự cố thật, alert quan trọng dễ bị chìm.
- Tạo alert fatigue.

---

## Actionable alert là gì?

Actionable alert là alert có ý nghĩa thực tế và cần con người xử lý.

Một alert tốt nên có:

- Ảnh hưởng trực tiếp đến user hoặc có nguy cơ ảnh hưởng user rõ ràng.
- Có ngưỡng cụ thể.
- Có thời gian kéo dài đủ lâu để tránh spike ngắn.
- Có severity phù hợp.
- Có owner rõ ràng.
- Có hướng xử lý hoặc runbook.
- Khi alert bắn, người nhận biết cần làm gì tiếp theo.

### Ví dụ actionable alert

```text
P95 latency > 500ms trong 10 phút và error rate > 2%.
```

Alert này actionable vì:

- Có ảnh hưởng đến trải nghiệm user.
- Có ngưỡng rõ ràng.
- Có thời gian kéo dài đủ lâu.
- Có thể điều tra theo hướng: kiểm tra deploy mới, database latency, dependency lỗi, CPU/memory saturation.

---

