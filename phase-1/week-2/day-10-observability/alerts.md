# Day 10 — Alert Design

## 1. Alert rule cho web app

### Alert 1 — High latency

Mục tiêu: phát hiện khi người dùng bắt đầu thấy web app chậm.

Ví dụ rule:

```yaml
- alert: HighLatency
  expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "P95 latency is higher than 500ms"
    description: "Web app P95 latency has been above 500ms for 10 minutes."
