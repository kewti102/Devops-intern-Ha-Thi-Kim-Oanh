# 1. So sánh giữa mô hình TCP/IP và mô hình OSI

Mô hình OSI gồm 7 tầng đó là: Tầng Ứng Dụng - Tầng Trình Diễn - Tầng Phiên - Tầng Giao Vận - Tầng Mạng - Tầng Liên Kết Dữ Liệu - Tầng Vật Lý.

Mô hình TCP/IP gồm 4 tầng đó là: Tầng Ứng Dụng - Tầng Giao Vận - Tầng Mạng - Tầng Truy Cập Mạng.

Mô hình TCP/IP được tổ chức thành 4 tầng, mỗi tầng nhận một nhóm các nhiệm vụ cụ thể và làm việc với các tầng khác. Ta sẽ so sánh qua nhiệm vụ mỗi tầng.

## Network Access Layer - Tầng truy cập mạng

Tương ứng với hai tầng Physical Layer và Data Link Layer trong mô hình OSI, tầng Network Access Layer trong mô hình TCP/IP đảm bảo việc gửi và nhận dữ liệu trên phương tiện vật lý của mạng.

Tầng này xử lý tất cả vấn đề liên quan tới việc dữ liệu được truyền từ thiết bị này sang thiết bị khác. Bao gồm việc đóng gói dữ liệu thành khung (Frame), xác định địa chỉ vật lý và kiểm soát quyền truy cập vào môi trường truyền dẫn.

## Network/Internet Layer - Tầng mạng

Tầng mạng có trách nhiệm chính trong việc định tuyến các gói tin từ nguồn đến đích.

Tầng này sử dụng giao thức IP để xác định địa chỉ duy nhất cho mỗi thiết bị và quyết định đường đi của dữ liệu trong mạng.

Tầng mạng đảm nhận việc phân mảnh và tái tổ hợp các gói tin, xử lý lỗi và cập nhật các thông tin định tuyến.

## Transport Layer - Tầng giao vận

Tầng giao vận chịu trách nhiệm cho việc truyền dữ liệu đáng tin cậy giữa các ứng dụng chạy trên các thiết bị khác nhau.

Nó đảm bảo dữ liệu được truyền một cách chính xác, không bị lỗi và theo thứ tự đúng.

Tầng giao vận thực hiện kiểm soát lỗi, kiểm soát luồng dữ liệu và cung cấp các cơ chế truyền thông đặc biệt như TCP (UDP).

## Application Layer - Tầng ứng dụng

Tầng ứng dụng trong mô hình TCP/IP cung cấp các dịch vụ mạng cần thiết cho các ứng dụng mà người dùng sử dụng, như trình duyệt Web, Email và các dịch vụ truyền File.

Tầng ứng dụng cung cấp các giao thức ứng dụng như HTTP, SMTP, FTP,... đảm bảo người dùng có thể tương tác với mạng một cách suôn sẻ và hiệu quả.

## Sự giống nhau

* Đều có phân lớp.
* Đều có lớp Network và Transport.
* Cùng sử dụng kỹ thuật chuyển Packet.

## Sự khác nhau

### Phương pháp tiếp cận

* OSI: Tiếp cận theo chiều dọc.
* TCP/IP: Tiếp cận theo chiều ngang.

### Thiết kế

* OSI: Phát triển mô hình trước sau đó sẽ phát triển giao thức.
* TCP/IP: Các giao thức được thiết kế trước sau đó phát triển mô hình sau.

### Truyền thông

* OSI: Lớp Transport chỉ xác định hướng kết nối.
* TCP/IP: Hỗ trợ cả kết nối TCP và UDP.

### Độ tin cậy và phổ biến

* OSI: Nhiều người cho rằng đây chỉ là mô hình cũ, chỉ để tham khảo, số người sử dụng còn hạn chế hơn so với TCP/IP.
* TCP/IP: Được chuẩn hóa, nhiều người tin cậy và sử dụng phổ biến trên toàn cầu.

# 2. TCP 3-Way Handshake

```text
Client                          Server

SYN      -------------------->  (Client yêu cầu kết nối)

          <-------------------- SYN-ACK
                                (Đồng ý, gửi lại Sequence Number của Server)

ACK      -------------------->  (Client xác nhận)

Kết nối ESTABLISHED
```

## Explain

* Flag SYN: Yêu cầu kết nối.
* Flag ACK: Xác nhận.
* Flag FIN: Đóng kết nối bình thường.
* Flag RST: Reset kết nối ngay lập tức.

# 3. Khi nào chọn UDP thay TCP? Ví dụ thực tế

* UDP là giao thức lớp vận chuyển của giao thức Internet (IP), phù hợp với các ứng dụng thời gian thực và nhạy cảm về thời gian như truyền phát Video, DNS và VoIP.

* UDP được sử dụng thay TCP khi:

  * Không cần bên Server xác thực 3 bước.
  * Cần phản hồi nhanh.
  * Độ trễ thấp.
  * Streaming liên tục.
  * Có thể chấp nhận việc mất một vài gói tin.
  * Không cần truyền lại dữ liệu.

Ví dụ:

* Game Online thời gian thực.
* Gọi Video/VoIP.
* Livestream.
* Truy vấn DNS.

# 4. CIDR

* /24 - 256 IP
* /22 - 1024 IP
* /16 - 65536 IP

# 5. Tại sao có Private IP Range?

Private IP dùng trong mạng nội bộ để tiết kiệm IPv4 công cộng.

# 6. NAT là gì? Phân biệt SNAT vs DNAT

NAT là Network Address Translation - tức là dịch địa chỉ mạng. NAT cho phép chuyển đổi địa chỉ IP riêng thành địa chỉ IP công cộng và ngược lại.

## Chức năng chính

* Tiết kiệm IP công cộng: Giảm thiểu tình trạng khan hiếm IPv4 bằng cách cho phép nhiều thiết bị chia sẻ một địa chỉ IP công cộng.
* Che dấu IP bên trong LAN: Ẩn địa chỉ mạng nội bộ khỏi mạng bên ngoài.
* Dịch địa chỉ IP: Chuyển từ Private IP sang Public IP trước khi ra Internet.
* Quản lý truy cập: Lọc gói tin, cho phép hoặc cấm truy cập đến Port cụ thể.

## SNAT - Static NAT - NAT tĩnh

* Ánh xạ 1-1 (một Private IP → một Public IP cố định).
* Cơ chế gán cứng, Private IP luôn Map với Public IP tương ứng.
* Ứng dụng: NAT Server (Web Server, Email Server cần truy cập Internet từ bên ngoài).
* Ưu điểm: Che giấu IP nguồn, giảm nguy cơ tấn công mạng.
* Nhược điểm: Tốn kém, cần số lượng Public IP tương ứng với số thiết bị.

## DNAT - Dynamic NAT - NAT động

* Ánh xạ 1-n (một Private IP → Public IP từ Pool/Group).
* Cơ chế: Tạo bảng ánh xạ động từ Private IP sang Public IP trong Pool.
* Ứng dụng: Khi nhiều User trong mạng cần truy cập ra Internet.
* Ưu điểm: Quản lý linh động, không cần gán cứng.
* Nhược điểm: Vẫn tốn kém vì cần nhiều Public IP để tạo Pool.

# 7. Sự khác nhau giữa Forward Proxy và Reverse Proxy

Proxies đóng vai trò quan trọng trong quản lý luồng dữ liệu máy khách và máy chủ.

## Forward Proxy

Hoạt động thay mặt Client để nâng cao quyền riêng tư và kiểm soát quyền truy cập.

* Được triển khai trước Client (trong mạng nội bộ).
* Mục đích ẩn danh Client, kiểm soát truy cập.
* Bảo vệ Client khi ra Internet.
* Cấu hình Proxy do Client thiết lập.
* Cache ở Client Side.
* Ứng dụng trong mạng doanh nghiệp, trường học.

## Reverse Proxy

Hoạt động thay mặt Server để tối ưu hóa hiệu suất và bảo mật.

* Được triển khai trước Backend Server.
* Mục đích bảo vệ Server, Load Balancing, tối ưu hiệu suất.
* Bảo vệ Backend Server khỏi tấn công.
* Client không biết có Proxy.
* Hỗ trợ phân phối tải.
* Cache Server Responses để giảm tải.
* Ứng dụng trong các hệ thống Web có nhiều Backend Server.
