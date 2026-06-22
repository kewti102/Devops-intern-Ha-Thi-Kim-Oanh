**1. So sánh giữa mô hình TCP/IP và mô hình OSI:**

Mô hình OSI gồm 7 tầng đó là: Tầng Ứng Dụng - Tầng Trình Diễn - Tầng Phiên - Tầng Giao Vận - Tầng Mạng - Tầng Liên Kết Dữ Liệu - Tầng Vật Lý.

Mô hình TCP/IP gồm 4 tầng đó là: Tầng Ứng Dụng - Tầng Giao Vận - Tầng Mạng - Tầng Truy Cập Mạng.

Mô hình TCP/IP được tổ chức thành 4 tầng, mỗi tầng nhận một nhóm các nhiệm vụ cụ thể và làm việc với các tầng khác. Ta sẽ so sánh qua nhiệm vụ mỗi tầng.

Network Access Layer - Tầng truy cập mạng: Tương ứng với hai tầng Physical Layer và Data Link Layer trong mô hình OSI, tầng Network Access Layer trong mô hình TCP/IP đảm bảo việc gửi và nhận dữ liệu trên phương tiện vật lý của mạng. Tầng này xử lý tất cả vấn đề liên quan tới việc dữ liệu được truyền từ thiết bị này sang thiết bị khác. Bao gồm việc đóng gói dữ liệu thành khung (frame), xác định địa chỉ vật lý, và kiểm soát quyền truy cập vào môi trường truyền dẫn.
Network/Internet Layer - Tầng mạng: Tầng mạng có trách nhiệm chính trong việc định tuyến các gói tin từ nguồn đến đích. Tầng này sử dụng giao thức IP để xác định địa chỉ duy nhất cho mỗi thiết bị và quyết định đường đi của dữ liệu trong mạng. Tầng mạng đảm nhận việc phân mảnh và tái tổ hợp các gói tin, xử lý lỗi và cập nhật các thông tin định tuyến.
Transport Layer - Tầng giao vận: Tầng giao vận chịu trách nhiệm cho việc truyền dữ liệu đáng tin cậy giữa các ứng dụng chạy trên các thiết bị khác nhau. Nó đảm bảo dữ liệu được truyền một cách chính xác, không bị lỗi và theo thứ tự đúng.

Tầng giao vận thực hiện kiểm soát lỗi, kiểm soát luồng dữ liệu và cung cấp các cơ chế truyền thông đặc biệt như TCP (UDP).

Application Layer - Tầng ứng dụng: Tầng ứng dụng trong mô hình TCP/IP cung cấp các dịch vụ mạng cần thiết cho các ứng dụng mà người dùng sử dụng, như trình duyệt web, email và các dịch vụ truyền file.

Tầng ứng dụng cung cấp các giao thức ứng dụng như HTTP, SMTP, FTP,..., đảm bảo người dùng có thể tương tác với mạng một cách suôn sẻ và hiệu quả.

Sự giống nhau: Mô hình OSI và TCP/IP có một số điểm chung như sau: đều có phân lớp, đều có lớp Network và Transport, cùng sử dụng kỹ thuật chuyển packet.

Sự khác nhau:

Phương pháp tiếp cận:
OSI: tiếp cận theo chiều dọc.
TCP/IP: tiếp cận theo chiều ngang.
Thiết kế:
OSI: Phát triển mô hình trước sau đó sẽ phát triển giao thức.
TCP/IP: Các giao thức được thiết kế trước sau đó phát triển mô hình sau.
Truyền thông:
OSI: Lớp Transport chỉ xác định hướng kết nối.
TCP/IP: Hỗ trợ cả kết nối TCP và UDP.
Độ tin cậy và phổ biến:
OSI: Nhiều người cho rằng đây chỉ là mô hình cũ, chỉ để tham khảo, số người sử dụng còn hạn chế hơn so với TCP/IP.
TCP/IP: Được chuẩn hóa, nhiều người tin cậy và sử dụng phổ biến trên toàn cầu.
**2. TCP 3-way Handshake**
client             Server

SYN      -------->         (client yêu cầu kết nối)

          <--------  SYN-ACK     (Đồng ý, gửi lại số Sequence Number của Server)

ACK      -------->         (Client xác nhận, kết nối ESTABLISHED)

Explain:

flag SYN: yêu cầu kết nối.

flag ACK: Xác nhận.

flag FIN: đóng kết nối bình thường.

flag RST: reset kết nối ngay lập tức.

**3. Khi nào chọn UDP thay TCP? Ví dụ thực tế.**
UDP là giao thức lớp vận chuyển của giao thức Internet (IP) cung cấp khả năng phù hợp với các ứng dụng thời gian thực và nhạy cảm về thời gian như truyền phát video, DNS và VoIP.
UDP được gửi đi thay cho TCP khi không cần bên server xác thực 3 bước, cần phản hồi nhanh, độ trễ thấp, streaming liên tục, có thể chấp nhận việc mất một vài gói tin (không cần truyền lại).

Ví dụ: Game online thời gian thực, gọi Video/VoIP, livestream, truy vấn DNS.

**4. CIDR:**

/24 - 256 IP

/16 - 65536 IP

/22 - 1024 IP

**5. Tại sao có private IP range?**

Private IP dùng trong mạng nội bộ để tiết kiệm IPv4 công cộng.

**6. NAT là gì? Phân biệt SNAT vs DNAT.**

NAT là Network Address Translation - tức là dịch địa chỉ mạng. NAT cho phép chuyển đổi địa chỉ IP riêng thành địa chỉ IP công cộng và ngược lại.

Chức năng chính:

Tiết kiệm IP công cộng: Giảm thiểu tình trạng khan hiếm IPv4 bằng cách cho phép nhiều thiết bị chia sẻ một địa chỉ IP công cộng.
Che dấu IP bên trong LAN: Ẩn địa chỉ mạng nội bộ khỏi mạng bên ngoài.
Dịch địa chỉ IP: Chuyển từ Private IP sang Public IP trước khi ra Internet.
Quản lý truy cập: Lọc gói tin, cho phép/cấm truy cập đến port cụ thể.

SNAT và DNAT là 2 trong 3 loại NAT phổ biến trong hệ thống mạng. Trong đó:

SNAT - Static NAT - NAT tĩnh:
Ánh xạ 1-1 (một private IP -> một public IP cố định).
Cơ chế gán cứng, private IP luôn map với public IP tương ứng.
Ứng dụng: NAT server (web server, email server cần truy cập Internet từ bên ngoài).
Ưu điểm: Che giấu IP nguồn, giảm nguy cơ tấn công mạng.
Nhược điểm: Tốn kém - cần số lượng public IP tương ứng với số thiết bị.
DNAT - Dynamic NAT - NAT động:
Ánh xạ 1-n (một private IP -> public IP từ pool/group).
Cơ chế: tạo bảng ánh xạ động từ private IP sang public IP trong pool.
Ứng dụng: Khi nhiều user trong mạng cần truy cập ra Internet.
Ưu điểm: Quản lý linh động, không cần gán cứng.
Nhược điểm: Vẫn tốn kém vì cần nhiều public IP để tạo pool.
**7. Sự khác nhau giữa Forward Proxy và Reverse Proxy**

Proxies đóng vai trò quan trọng trong quản lý luồng dữ liệu máy khách và máy chủ.

Forward Proxy: hoạt động thay mặt client để nâng cao quyền riêng tư và kiểm soát quyền truy cập.
Reverse Proxy: hoạt động thay mặt server để tối ưu hóa hiệu suất và bảo mật.
Forward Proxy: được triển khai trước client (trong mạng nội bộ), mục đích ẩn danh client, kiểm soát truy cập; bảo vệ client khi ra Internet, cấu hình proxy do client viết, cache ở client side, ứng dụng trong mạng doanh nghiệp, học đường.
Reverse Proxy: được triển khai trước server (trước backend server), mục đích bảo vệ server, load balancing, tối ưu hiệu suất; bảo mật bảo vệ backend server khỏi tấn công, client không biết có proxy, hỗ trợ phân phối tải, cache server responses để giảm tải, hệ thống web với nhiều backend server.

