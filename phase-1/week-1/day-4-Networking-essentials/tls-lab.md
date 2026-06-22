// =================================================================
// 1. DNS RESOLUTION (Phân giải tên miền ra IP)
// =================================================================
*   Trying 172.66.147.243:443...  // <-- Hệ thống đã phân giải example.com ra IP 172.66.147.243
// =================================================================
// 2. TCP CONNECT (Thiết lập 3-way handshake)
// =================================================================
* Connected to example.com (172.66.147.243) port 443 (#0)  // <-- Dau hieu TCP 3-way handshake thanh cong

// =================================================================
// 3. TLS HANDSHAKE (Bắt tay mã hóa, chọn Cipher và xác minh Cert)
// =================================================================
* ALPN, offering h2
* ALPN, offering http/1.1
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.0 (OUT), TLS header, Certificate Status (22):
* TLSv1.3 (OUT), TLS handshake, Client hello (1):   // <-- Client gui loi chao
* TLSv1.2 (IN), TLS header, Certificate Status (22):  
* TLSv1.3 (IN), TLS handshake, Server hello (2): // <-- Server phan hoi
* TLSv1.2 (IN), TLS header, Finished (20):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):   // Server gui certificate chain
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.2 (OUT), TLS header, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384	// <-- [CIPHER] Thuật toán mã hóa được thống nhất
* ALPN, server accepted to use h2
* Server certificate: 		// <-- [CERT] Thông tin chứng chỉ SSL của Server
*  subject: CN=example.com
*  start date: May 31 21:39:12 2026 GMT
*  expire date: Aug 29 21:41:26 2026 GMT
*  subjectAltName: host "example.com" matched cert's "example.com"
*  issuer: C=US; O=SSL Corporation; CN=Cloudflare TLS Issuing ECC CA 3
*  SSL certificate verify ok.
* Using HTTP2, server supports multiplexing
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* Using Stream ID: 1 (easy handle 0x64c5fa20ea30)
* TLSv1.2 (OUT), TLS header, Supplemental data (23):

// =================================================================
// 4. HTTP REQUEST HEADERS (Client gửi yêu cầu đi)
// =================================================================
> GET / HTTP/2    		// <-- Method: GET, giao thức HTTP/2
> Host: example.com		// <-- Tên miền đang yêu cầu
> user-agent: curl/7.81.0	// <-- Ứng dụng đang gửi request
> accept: */*
> 
// =================================================================
// 5. HTTP RESPONSE HEADERS (Server trả lời về)
// =================================================================
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
< HTTP/2 200 			// <-- Status Code: 200 OK (Thành công)
< date: Mon, 22 Jun 2026 08:27:27 GMT
< content-type: text/html	// <-- Loại dữ liệu trả về là HTML
< server: cloudflare
< last-modified: Sat, 20 Jun 2026 20:45:06 GMT
< allow: GET, HEAD
< accept-ranges: bytes
< age: 5
< cf-cache-status: HIT
< cf-ray: a0f9dfba9d80e2f7-HKG
< 
* TLSv1.2 (IN), TLS header, Supplemental data (23):
<!doctype html><html lang="en"><head><title>Example Domain</title><link rel="icon" href="data:,"><meta name="viewport" content="width=device-width, initial-scale=1"><style>body{background:#eee;width:60vw;margin:15vh auto;font-family:system-ui,sans-serif}h1{font-size:1.5em}div{opacity:0.8}a:link,a:visited{color:#348}</style></head><body><div><h1>Example Domain</h1><p>This domain is for use in documentation examples without needing permission. Avoid use in operations.</p><p><a href="https://iana.org/domains/example">Learn more</a></p></div></body></html>
* TLSv1.2 (IN), TLS header, Supplemental data (23):





2. TLS Handshake don gian hoa:
Client                                      Server
  |                                           |
  | ----------- ClientHello ----------------> |
  |        (SNI, ALPN, cipher suites)         |
  |                                           |
  | <----------- ServerHello ---------------- |
  | <----------- Certificate ---------------- |
  | <------ Encrypted Extensions ------------ |
  | <------------ Finished ------------------ |
  |                                           |
  | ------------ Finished ------------------> |
  |                                           |
  | ====== Encrypted HTTP Traffic ========    |
  | <========== HTTP Response ============>   |

SNI	Cho server biết client muốn truy cập domain nào
ALPN	Chọn HTTP/1.1 hay HTTP/2
OCSP	Kiểm tra cert có bị thu hồi không
SAN	Danh sách domain được cert bảo vệ
