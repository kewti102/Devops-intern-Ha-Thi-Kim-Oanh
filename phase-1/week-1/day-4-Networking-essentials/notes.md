## 1. So sánh giữa mô hình TCP/IP và mô hình OSI

Mô hình OSI gồm 7 tầng đó là: Tầng Ứng Dụng - Tầng Trình Diễn - Tầng Phiên - Tầng Giao Vận - Tầng Mạng - Tầng Liên Kết Dữ Liệu - Tầng Vật Lý.

Mô hình TCP/IP gồm 4 tầng đó là: Tầng Ứng Dụng - Tầng Giao Vận - Tầng Mạng - Tầng Truy Cập Mạng.

Mô hình TCP/IP được tổ chức thành 4 tầng, mỗi tầng nhận một nhóm các nhiệm vụ cụ thể và làm việc với các tầng khác. Ta sẽ so sánh qua nhiệm vụ mỗi tầng.

### Network Access Layer - Tầng truy cập mạng

Tương ứng với hai tầng Physical Layer và Data Link Layer trong mô hình OSI, tầng Network Access Layer trong mô hình TCP/IP đảm bảo việc gửi và nhận dữ liệu trên phương tiện vật lý của mạng.

Tầng này xử lý tất cả vấn đề liên quan tới việc dữ liệu được truyền từ thiết bị này sang thiết bị khác. Bao gồm việc đóng gói dữ liệu thành khung (frame), xác định địa chỉ vật lý, và kiểm soát quyền truy cập vào môi trường truyền dẫn.

### Network/Internet Layer - Tầng mạng

Tầng mạng có trách nhiệm chính trong việc định tuyến các gói tin từ nguồn đến đích.

Tầng này sử dụng giao thức IP để xác định địa chỉ duy nhất cho mỗi thiết bị và quyết định đường đi của dữ liệu trong mạng.

Tầng mạng đảm nhận việc phân mảnh và tái tổ hợp các gói tin, xử lý lỗi và cập nhật các thông tin định tuyến.

### Transport Layer - Tầng giao vận

Tầng giao vận chịu trách nhiệm cho việc truyền dữ liệu đáng tin cậy giữa các ứng dụng chạy trên các thiết bị khác nhau.

Nó đảm bảo dữ liệu được truyền một cách chính xác, không bị lỗi và theo thứ tự đúng.

Tầng giao vận thực hiện kiểm soát lỗi, kiểm soát luồng dữ liệu và cung cấp các cơ chế truyền thông đặc biệt như TCP (UDP).

### Application Layer - Tầng ứng dụng

Tầng ứng dụng trong mô hình TCP/IP cung cấp các dịch vụ mạng cần thiết cho các ứng dụng mà người dùng sử dụng, như trình duyệt web, email và các dịch vụ truyền file.

Tầng ứng dụng cung cấp các giao thức ứng dụng như HTTP, SMTP, FTP,..., đảm bảo người dùng có thể tương tác với mạng một cách suôn sẻ và hiệu quả.

### Sự giống nhau

- Đều có phân lớp.
- Đều có lớp Network và Transport.
- Cùng sử dụng kỹ thuật chuyển packet.

### Sự khác nhau

#### Phương pháp tiếp cận

- OSI: tiếp cận theo chiều dọc.
- TCP/IP: tiếp cận theo chiều ngang.

#### Thiết kế

- OSI: Phát triển mô hình trước sau đó sẽ phát triển giao thức.
- TCP/IP: Các giao thức được thiết kế trước sau đó phát triển mô hình sau.

#### Truyền thông

- OSI: Lớp Transport chỉ xác định hướng kết nối.
- TCP/IP: Hỗ trợ cả kết nối TCP và UDP.

#### Độ tin cậy và phổ biến

- OSI: Nhiều người cho rằng đây chỉ là mô hình cũ, chỉ để tham khảo, số người sử dụng còn hạn chế hơn so với TCP/IP.
- TCP/IP: Được chuẩn hóa, nhiều người tin cậy và sử dụng phổ biến trên toàn cầu.
