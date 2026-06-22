1. Thứ tự các packet bắt được
HTTP (Port 80)
SYN
SYN-ACK
ACK
HTTP GET /
ACK
HTTP/1.1 200 OK
HTTPS (Port 443)
SYN
SYN-ACK
ACK
TLS Client Hello
TLS Server Hello
TLS Change Cipher Spec
TLS Application Data (Encrypted)

1.2. Bat duoc request day du roi.
2. HTTPS có bắt được payload không?

Không.

Sau khi TLS handshake hoàn thành, toàn bộ dữ liệu HTTP được mã hóa thành TLS Application Data.

Wireshark và tcpdump chỉ nhìn thấy:

Địa chỉ IP
Port
Kích thước gói tin
Loại bản ghi TLS

Nhưng không thể đọc được nội dung thực tế của HTTP request và response nếu không có khóa giải mã.


## Screenshot

- screenshots/tcpdump-http-https.png
