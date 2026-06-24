## 1. Image gồm những lớp gì? Vì sao layer được cache?

Docker Image được tạo từ nhiều layer (lớp) chỉ đọc (read-only). Mỗi lệnh trong Dockerfile như `FROM`, `RUN`, `COPY`, `ADD` sẽ tạo ra một layer mới.

Các layer sẽ lần lượt tương ứng với:

* Base image (node:20-alpine)
* Tạo thư mục làm việc (WORKDIR)
* Copy file package.json
* Cài đặt dependency (npm install)
* Copy source code
* Cấu hình lệnh chạy container (CMD)

Layer được cache vì Docker sẽ lưu kết quả của từng layer sau mỗi lần build. Nếu một layer không thay đổi thì Docker sẽ tái sử dụng layer đó thay vì thực thi lại, giúp tăng tốc độ build và tiết kiệm tài nguyên.

## 2. Sự khác nhau giữa COPY và ADD

Cả `COPY` và `ADD` đều dùng để đưa file từ host vào Docker image.

### COPY

- Chỉ sao chép file hoặc thư mục từ host vào image.
- Chức năng đơn giản, dễ hiểu.
- Được khuyến nghị sử dụng trong hầu hết trường hợp.

### ADD

Ngoài chức năng của `COPY`, `ADD` còn có thể:

- Tự động giải nén file nén cục bộ (`.tar`, `.tar.gz`, ...).
- Tải file từ URL (không khuyến khích sử dụng).

## 3. CMD vs ENTRYPOINT – khi nào dùng cái nào?

### CMD

CMD dùng để chỉ định lệnh mặc định sẽ chạy khi container khởi động.

Đặc điểm:

- Có thể bị ghi đè hoàn toàn khi chạy `docker run`.
- Thường dùng để cung cấp tham số hoặc lệnh mặc định.

### ENTRYPOINT

ENTRYPOINT dùng để chỉ định chương trình chính của container.

Đặc điểm:

- Khó bị ghi đè hơn.
- Mọi tham số truyền vào `docker run` sẽ được nối thêm vào sau ENTRYPOINT.
- Thường dùng khi container hoạt động như một executable.

## 4. Tại sao nên có `.dockerignore`?

File `.dockerignore` dùng để loại trừ các file hoặc thư mục không cần thiết khỏi Docker build context.

Lợi ích:

- Giúp build nhanh hơn.
- Giảm dung lượng image.
- Tránh đưa các file nhạy cảm vào image.
- Giảm số lần Docker phải rebuild các layer khi các file không liên quan thay đổi.

## 5. EXPOSE thực sự làm gì? Có tự mở port không?

`EXPOSE` dùng để khai báo (documentation) rằng container sẽ lắng nghe trên một cổng cụ thể.

EXPOSE không tự mở port ra ngoài host.
Để truy cập được từ bên ngoài vẫn cần public port
`docker run -p 3000:3000 demo-app`

### 6. Tại sao không nên chạy container as root?

Không nên chạy container bằng tài khoản root vì lý do bảo mật.

Nếu ứng dụng trong container bị khai thác lỗ hổng, kẻ tấn công có quyền root bên trong container và có thể gây ảnh hưởng đến host hoặc các container khác.

Rủi ro khi chạy bằng root:

* Tăng khả năng leo thang đặc quyền (privilege escalation).
* Có thể truy cập hoặc sửa đổi tài nguyên ngoài ý muốn.
* Vi phạm nguyên tắc "Least Privilege" (cấp quyền tối thiểu cần thiết).
