1. Giai thich ouput cua lenh trace:
Lệnh `dig +trace google.com` hiển thị toàn bộ quá trình phân giải DNS.

### Step 1: Root DNS

Root DNS trả về danh sách root name servers (a.root-servers.net đến m.root-servers.net) và chỉ dẫn truy vấn tới các máy chủ quản lý miền `.com`.

### Step 2: TLD DNS (.com)

Các TLD servers như `a.gtld-servers.net` trả về danh sách authoritative name servers của `google.com`.

Ví dụ:

- ns1.google.com
- ns2.google.com
- ns3.google.com
- ns4.google.com

### Step 3: Authoritative DNS

Authoritative DNS của Google chứa các bản ghi thực tế của domain và trả lời truy vấn cuối cùng.

### DNSSEC

Output chứa các bản ghi DS, RRSIG và NSEC3 dùng để xác thực dữ liệu DNS và đảm bảo tính toàn vẹn của quá trình phân giải tên miền.

### Lỗi cuối

Output xuất hiện thông báo:

`network unreachable`

do máy Ubuntu không có kết nối IPv6 nên không thể truy vấn các DNS server qua IPv6. Đây không phải lỗi của Google DNS.
2. 
/etc/hosts: File ánh xạ IP - Domain cục bộ. Có độ ưu tiên cao nhất, hệ điều hành sẽ check file này đầu tiên.

/etc/resolv.conf: File chứa địa chỉ của các máy chủ DNS (Nameserver) để hệ thống gửi query khi không tìm thấy trong /etc/hosts (VD: nameserver 8.8.8.8).

systemd-resolved: Dịch vụ chạy ngầm trên Linux giúp quản lý độ phân giải DNS, cung cấp bộ nhớ đệm (caching) cục bộ để truy vấn nhanh hơn. Thường nó trỏ /etc/resolv.conf về chính nó (127.0.0.53).
