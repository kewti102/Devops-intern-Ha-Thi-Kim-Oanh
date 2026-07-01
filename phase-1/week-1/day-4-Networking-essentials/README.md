# Day 4 — Networking Essentials

## Mục tiêu

Trong bài thực hành này, em tìm hiểu các kiến thức nền tảng về mạng máy tính, bao gồm mô hình OSI/TCP-IP, giao thức TCP và UDP, DNS, HTTP/HTTPS, TLS, packet capture bằng tcpdump và các khái niệm về port, socket trên Linux.

---

## Nội dung thực hiện

### Part A — Networking Primer

Hoàn thành phần lý thuyết:

* So sánh mô hình OSI 7 lớp và TCP/IP 4 lớp.
* Giải thích TCP 3-way handshake.
* Phân biệt TCP và UDP.
* Tính số lượng địa chỉ IP trong các CIDR /16, /22, /24.
* Giải thích Private IP Range.
* Tìm hiểu NAT, SNAT và DNAT.
* So sánh Forward Proxy và Reverse Proxy.

Tài liệu: `notes.md`

---

### Part B — DNS Lab

Thực hiện các lệnh:

```bash
dig google.com
dig +trace google.com
dig MX gmail.com
dig TXT google.com
dig @8.8.8.8 example.com
nslookup example.com
```

Nội dung tìm hiểu:

* Quy trình DNS Resolution.
* Ý nghĩa của kết quả `dig +trace`.
* DNS Record: A, AAAA, CNAME, MX, TXT.
* Cấu hình `/etc/hosts`.
* Vai trò của `/etc/hosts`, `/etc/resolv.conf` và `systemd-resolved`.

Tài liệu: `dns-lab.md`
Ket qua luu trong folder screenshots/dns-lab.
---

### Part C — HTTP/HTTPS & TLS

Phân tích kết quả:

```bash
curl -v https://example.com
openssl s_client -connect example.com:443 -showcerts
```

Nội dung:

* DNS Resolution.
* TCP Connection.
* TLS 1.3 Handshake.
* HTTP Request/Response.
* Certificate Chain.
* Vai trò của:

  * SNI
  * ALPN
  * OCSP
  * SAN

Tài liệu: `tls-lab.md`
Ket qua luu trong folder screenshots/tls-lab
---

### Part D — Packet Capture với tcpdump

Thu thập lưu lượng mạng bằng:

```bash
sudo tcpdump -i any -nn -s 0 -w trace.pcap host example.com
```

Phân tích:

* TCP 3-way Handshake.
* HTTP GET Request.
* HTTP Response.
* Vì sao HTTPS payload không thể đọc trực tiếp.
* So sánh HTTP và HTTPS ở mức packet.

Tài liệu: `tcpdump-lab.md`

Ket qua luu trong folder tcpdump-lab

```text
trace.pcap
```

---

### Part E — Port & Socket

Thực hành với Netcat:

```bash
nc -l 9000
```

Kiểm tra socket:

```bash
ss -tlnp | grep 9000
```

Kết nối client:

```bash
nc 127.0.0.1 9000
```

Nội dung tìm hiểu:

* Port Listening.
* TCP Socket.
* Trạng thái LISTEN.
* Trạng thái ESTABLISHED.
* Trạng thái TIME_WAIT.
* Trạng thái CLOSE_WAIT.
* So sánh:

  * `ss -tln`
  * `ss -uln`
  * `ss -anp`
Ket qua luu trong folder PartE
---

## Cấu trúc thư mục

```text
day-4-Networking-essentials/
├── README.md
├── notes.md
├── dns-lab.md
├── tls-lab.md
├── tcpdump-lab.md
├── trace.pcap
└── screenshots/
```


---

## Kết quả đạt được

Sau bài thực hành, em có thể:

* Hiểu kiến trúc mạng theo mô hình OSI và TCP/IP.
* Phân biệt TCP và UDP.
* Phân tích quá trình phân giải DNS.
* Đọc và hiểu HTTP/HTTPS request.
* Hiểu quy trình TLS Handshake và Certificate Chain.
* Sử dụng tcpdump để bắt và phân tích packet.
* Hiểu cách Linux quản lý port và socket.
* Sử dụng các công cụ mạng cơ bản như `dig`, `curl`, `openssl`, `tcpdump`, `ss` và `nc`.
