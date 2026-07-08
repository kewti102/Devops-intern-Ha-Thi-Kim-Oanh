# Day 10 — Observability Basics Notes

## 1. Phân biệt log vs metric vs trace

### Log

**Log** là dữ liệu ghi lại sự kiện chi tiết theo thời gian. Mỗi dòng log thường đại diện cho một event như request đi vào hệ thống, lỗi, warning, debug hoặc một hành động quan trọng nào đó.

Log thường có các trường:

- `timestamp`: thời điểm xảy ra sự kiện.
- `level`: mức độ log, ví dụ `INFO`, `WARN`, `ERROR`.
- `service`: service phát sinh log.
- `message`: nội dung chính.
- `context`: thông tin bổ sung như `order_id`, `trace_id`, `user_id`, lỗi cụ thể,...

Ví dụ log:

```json
{
  "timestamp": "2026-07-09T00:10:23.145Z",
  "level": "ERROR",
  "service": "payment-service",
  "trace_id": "abc123",
  "message": "Charge failed",
  "order_id": "ORD-9876",
  "error": "Timeout when calling bank-gateway"
}
```

Log phù hợp để debug chi tiết một lỗi cụ thể: lỗi xảy ra lúc nào, ở service nào, request nào bị lỗi và nguyên nhân lỗi là gì.

---

### Metric

**Metric** là số liệu được tổng hợp theo thời gian, thường được biểu diễn bằng đồ thị để theo dõi xu hướng tăng giảm của hệ thống.

Metric thường dùng để trả lời các câu hỏi như:

- CPU đang dùng bao nhiêu phần trăm?
- Memory còn bao nhiêu?
- Request rate tăng hay giảm?
- Latency trung bình hoặc P95 là bao nhiêu?
- Error rate có vượt ngưỡng không?

Ví dụ metric dạng Prometheus histogram:

```prometheus
payment_request_latency_seconds_bucket{le="0.5",service="payment-service"} 500
payment_request_latency_seconds_bucket{le="1",service="payment-service"} 900
payment_request_latency_seconds_count{service="payment-service"} 1000
```

Metric phù hợp để vẽ dashboard, đặt alert và theo dõi sức khỏe hệ thống theo thời gian.

---

### Trace

**Trace** là hành trình của một request khi đi qua nhiều service khác nhau trong hệ thống.

Một trace thường gồm nhiều **span**. Mỗi span đại diện cho một bước xử lý hoặc một lần gọi giữa các service.

Ví dụ trace:

```text
trace_id = "abc123"

Span 1: frontend → payment-service (50ms)
Span 2: payment-service → user-service (30ms)
Span 3: payment-service → bank-gateway (780ms, STATUS=ERROR, timeout)
```

Trace giúp xác định request bị chậm hoặc lỗi ở bước nào. Nó đặc biệt hữu ích trong hệ thống microservices, nơi một request có thể đi qua nhiều service trước khi hoàn thành.

---

### Tóm tắt

| Thành phần | Mục đích chính | Ví dụ sử dụng |
|---|---|---|
| Log | Ghi lại sự kiện chi tiết | Debug lỗi `Charge failed` của một order cụ thể |
| Metric | Đo số liệu theo thời gian | Theo dõi CPU, memory, latency, error rate |
| Trace | Theo dõi hành trình request qua nhiều service | Tìm service gây timeout trong flow thanh toán |

---

## 2. Pull-based Prometheus vs Push-based StatsD / OpenTelemetry Collector

### Pull-based — Prometheus

#### Cách hoạt động

Với mô hình **pull-based**, ứng dụng expose một HTTP endpoint, thường là:

```text
/metrics
```

Prometheus định kỳ pull/scrape endpoint đó để lấy metric. Ví dụ mỗi 15 giây Prometheus gọi:

```text
http://service:port/metrics
```

#### Ưu điểm

- Có thể mở trực tiếp `http://service:port/metrics` để xem app đang expose metric gì.
- Prometheus quyết định tần suất scrape. Nếu hệ thống quá tải, có thể giảm tần suất scrape mà không cần sửa code app.
- Nếu Prometheus tạm thời bị down, app không bị block vì app chỉ expose metric, không phải chủ động gửi metric đi.
- Prometheus biết danh sách target thông qua file config hoặc service discovery, nên dễ dùng cho hạ tầng tĩnh hoặc các service trong cùng network.
- Dễ kiểm tra target sống hay chết qua trang `/targets`.

#### Nhược điểm

- Target phải reachable từ Prometheus. Nếu app nằm sau NAT, firewall hoặc network khác thì khó scrape trực tiếp.
- Không thuận tiện cho container sống ngắn, batch job, Lambda/FaaS hoặc workload kết thúc rất nhanh.
- Với môi trường nhiều cluster/service, việc quản lý target hoặc service discovery có thể phức tạp.
- Với nhiều time series, việc expose và lưu metric có thể làm tăng tài nguyên sử dụng.

---

### Push-based — StatsD / OpenTelemetry Collector

#### Cách hoạt động

Với mô hình **push-based**, ứng dụng chủ động gửi metric đến một agent hoặc collector, ví dụ:

- StatsD server.
- OpenTelemetry Collector.
- Monitoring agent.

Collector nhận dữ liệu, xử lý, aggregate/filter rồi gửi tiếp về backend lưu trữ như Prometheus remote write, OTLP backend hoặc hệ thống monitoring khác.

#### Ưu điểm

- Phù hợp với job chạy ngắn, serverless hoặc edge workload. Job chạy vài giây có thể push metric ngay trước khi kết thúc.
- App chỉ cần outbound connection tới collector, phù hợp khi app nằm sau NAT, nhiều VPC hoặc multi-cloud.
- Collector có thể gom metric từ nhiều nơi, transform, normalize rồi gửi về nhiều backend.
- App chỉ cần biết gửi telemetry đến đâu, còn routing/transform do collector xử lý.

#### Nhược điểm

- Nếu dùng UDP như StatsD, metric có thể bị drop khi network lỗi hoặc collector quá tải.
- Khó debug hơn vì không có endpoint `/metrics` để mở trực tiếp xem app đang expose gì.
- Collector trở thành một thành phần hạ tầng riêng, cần được scale, monitor và đảm bảo high availability.
- Nếu collector down hoặc quá tải, có thể mất dữ liệu nếu không có buffer/retry tốt.

---

### Tóm tắt pull vs push

| Tiêu chí | Pull-based Prometheus | Push-based StatsD / OTel Collector |
|---|---|---|
| Cách hoạt động | Prometheus đi scrape target | App gửi metric đến collector |
| Phù hợp với | Service/hạ tầng chạy ổn định | Batch job, serverless, edge, multi-cloud |
| Debug | Dễ mở `/metrics` để xem | Phải xem ở collector/backend |
| Khả năng phát hiện target down | Dễ qua scrape failure | Khó hơn, vì app không gửi có thể do down hoặc không có traffic |
| Điểm cần quản lý | Prometheus scrape config/service discovery | Collector, buffer, retry, HA |

---

## 3. SLI / SLO / SLA khác nhau thế nào?

### SLI — Service Level Indicator

**SLI** là chỉ số đo lường chất lượng dịch vụ.

Ví dụ:

```text
SLI_availability = (số request trả 2xx + 3xx) / (tổng số request)
```

Nếu trong tháng có 1.000.000 request, trong đó 999.300 request thành công, thì:

```text
SLI_availability = 99.93%
```

SLI là thứ mình đo được từ hệ thống.

---

### SLO — Service Level Objective

**SLO** là mục tiêu nội bộ đặt ra cho một SLI.

Ví dụ:

```text
Availability của API thanh toán phải ≥ 99.95% trong mỗi cửa sổ 30 ngày.
```

Nếu SLI tháng này là `99.93%`, nhưng SLO là `99.95%`, nghĩa là team đã **vi phạm SLO nội bộ**. Khi đó team cần phân tích nguyên nhân và cải thiện hệ thống, ví dụ tăng redundancy, tối ưu code hoặc cải thiện dependency.

SLO thường được dùng nội bộ bởi team engineering/SRE để quản lý chất lượng dịch vụ.

---

### SLA — Service Level Agreement

**SLA** là cam kết chính thức với khách hàng, thường nằm trong hợp đồng và có thể kèm điều khoản bồi thường nếu không đạt.

Ví dụ:

```text
Cam kết uptime ≥ 99.9% mỗi tháng. Nếu không đạt, khách hàng được hoàn 15% phí dịch vụ của tháng đó.
```

SLA thường thấp hơn hoặc bằng SLO, vì SLA có ràng buộc pháp lý/thương mại.

---

### Ví dụ tổng hợp

Với API thanh toán:

```text
SLI:
Availability thực tế tháng này = 99.93%

SLO:
Availability phải ≥ 99.95% trong 30 ngày

SLA:
Cam kết với khách hàng uptime ≥ 99.9% mỗi tháng
```

Nếu SLI thực tế là `99.93%`:

- Đạt SLA vì `99.93% > 99.9%`, nên không phải bồi thường.
- Trượt SLO vì `99.93% < 99.95%`, nên team cần xem đây là cảnh báo chất lượng.

---

## 4. Cardinality nổ là gì, hậu quả?

### Cardinality là gì?

Trong observability, **cardinality** là số lượng tổ hợp khác nhau của metric name và label values.

Ví dụ metric có cardinality thấp:

```prometheus
http_requests_total{method="GET",status="200"}
http_requests_total{method="POST",status="500"}
```

Các label như `method` và `status` có số lượng giá trị ít, nên cardinality thấp.

Ví dụ metric có cardinality cao:

```prometheus
http_requests_total{user_id="123456",request_id="abc-xyz",path="/orders/98765"}
```

Các label như `user_id`, `request_id`, `session_id`, `email`, `full_url`, `order_id` thường có rất nhiều giá trị khác nhau. Điều này tạo ra số lượng time series cực lớn.

### Cardinality nổ là gì?

**Cardinality nổ** là tình huống số lượng giá trị khác nhau của label quá nhiều, khiến hệ thống metric/log/trace phình to mất kiểm soát.

Ví dụ không nên làm:

```prometheus
payment_request_total{user_id="u001"}
payment_request_total{user_id="u002"}
payment_request_total{user_id="u003"}
...
payment_request_total{user_id="u999999"}
```

Nếu mỗi user tạo ra một time series riêng, số lượng series sẽ tăng rất nhanh.

### Hậu quả

Cardinality nổ gây ra nhiều vấn đề:

- Tốn nhiều RAM.
- Tốn nhiều ổ cứng.
- I/O tăng mạnh.
- Index phình to.
- Query chậm.
- Dashboard load chậm.
- Alert có thể bị delay hoặc timeout.
- Hệ thống metric có thể bị quá tải hoặc sập.
- Chi phí hạ tầng/cloud monitoring tăng mạnh.
- Có quá nhiều series rác, khó quản lý và debug.

Ví dụ tốt hơn:

```prometheus
http_requests_total{method="GET",route="/orders/:id",status="200"}
```

