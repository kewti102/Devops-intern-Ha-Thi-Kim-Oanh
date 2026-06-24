1. 
### Tạo network

```bash
docker network create demo-net
```

Kết quả:

```text
f3bffca659ea467eb185128ef64fcbcb83c68d316af570e5a899a0dc973c664c
```

### Khởi chạy container app1

```bash
docker run -d \
  --name app1 \
  --network demo-net \
  -e NAME=app1 \
  demo-app:1.0.0
```

### Khởi chạy container app2

```bash
docker run -d \
  --name app2 \
  --network demo-net \
  -e NAME=app2 \
  demo-app:1.0.0
```

### Kiểm tra trạng thái container

```bash
docker ps
```

Kết quả:

```text
CONTAINER ID   IMAGE            STATUS
f4d6c3452318   demo-app:1.0.0   Up (healthy)   app1
200d0f3a638b   demo-app:1.0.0   Up (healthy)   app2
```

### Kiểm tra kết nối giữa các container

Từ container app1 gọi sang app2:

```bash
docker exec app1 wget -qO- http://app2:3000
```

Kết quả:

```json
{"msg":"hello from app2","ts":1782188782794}
```

Kết luận:

* Hai container nằm trong cùng network `demo-net`.
* app1 có thể truy cập app2 thông qua tên container.
* Docker DNS hoạt động bình thường.

---

2. 

```bash
docker run -d \
  --name postgres-demo \
  -e POSTGRES_PASSWORD=123456 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:16-alpine
```

### Truy cập PostgreSQL

```bash
docker exec -it postgres-demo psql -U postgres
```

### Tạo database mới

```sql
CREATE DATABASE demo;
```

### Kiểm tra danh sách database

```sql
\l
```

Kết quả:

```text
demo
postgres
template0
template1
```

### Khởi động lại container

```bash
docker restart postgres-demo
```

### Kiểm tra dữ liệu sau khi restart

```bash
docker exec -it postgres-demo psql -U postgres
```

```sql
\l
```

Kết quả:

```text
demo
postgres
template0
template1
```

Kết luận:

* Database `demo` vẫn còn sau khi restart container.
* Docker Volume `pgdata` hoạt động đúng.
* Dữ liệu được lưu trữ bên ngoài container.

3. 
### Tạo thư mục website

```bash
mkdir site
```

### Tạo file index.html

```bash
echo "<h1>Hello Docker</h1>" > site/index.html
```

### Chạy Nginx với bind mount

```bash
docker run -d \
  --name nginx-bind \
  -p 8081:80 \
  -v $(pwd)/site:/usr/share/nginx/html \
  nginx:1.27-alpine
```

### Truy cập website

Mở trình duyệt:

```text
http://localhost:8081
```

Kết quả:

```html
<h1>Hello Docker</h1>
```

### Chỉnh sửa nội dung website

```bash
echo "<h1>Hello Docker Day 5</h1>" > site/index.html
```

Refresh trình duyệt.

Kết quả:

```html
<h1>Hello Update Content</h1>
```

