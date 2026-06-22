1. So sanh giua mo hinh TCP/IP va mo hinh OSI:
Mo hinh OSI gom 7 tang do la: Tang Ung Dung - Tang trinh dien-Tang phien - Tang giao van - Tang Mang - Tang lien ket du lieu - Tang Vat ly
Mo hinh TCP/IP gom 4 tang do la: Tang ung dung-Tang giao van-Tang Mang-Tang truy cap mang

Mo hinh TCP/IP duoc to chuc thanh 4 tang, moi tang nhan mot nhom cac nhiem vu cu the va lam viec voi cac tang khac. Ta se so sanh qua nhiem vu moi tang.
- Network Access Layer-Tang truy cap mang: Tuong ung voi hai tang Physical Layer va Data Link Layer trong mo hinh OSI, tang Network Access Layer trong mo hinh TCP/IP dam bao viec gui va nhan du lieu tren phuong tien vat ly cua mang. Tang nay xu ly tat ca van de lien quan toi viec du lieu duoc truyen tu thiet bi nay sang thiet bi khac. Bao gom viec dong goi du lieu thanh khung(frame), xac dinh dia chi vat ly, va kiem soat quyen truy cap vao moi truong truyen dan. 
- Network/Internet Layer-Tang mang: Tang mang co trach nhiem chinh trong viec dinh tuyen cac goi tin tu nguon den dich. Tang nay su dung giao thuc IP de xac dinh dia chi duy nhat cho moi thiet bi va quyet dinh duong di cua du lieu trong mang. Tang mang dam nhan viec phan manh va tai to hop cac goi tin, xu ly loi va cap nhat cac thong tin dinh tuyen.
- Transport Layer-Tang giao van: Tang giao van chiu trach nhiem cho viec truyen du lieu dang tin cay giua cac ung dung chay tren cac thiet bi khac nhau. No dam bao du lieu duoc truyen mot cach chinh xac, khong bi loi va theo thu tu dung. 
Tang giao van thuc hien kiem soat loi, kiem soat luong du lieu va cung cap cac co che truyen thong dac biet nhu TCP(UDP).
- Application Layer-Tang ung dung: tang ung dung trong mo hinh TCP/IP cung cap cac dich vu mang can thiet cho cac ung dung ma nguoi dung su dung, nhu trinh duyet web, email va cac dich vu truyen file. 
Tang ung dung cung cap cac giao thuc ung dung nhu HTTP, SMTP, FTP,..., dam bao nguoi dung co the tuong tac voi mang mot cach suon se va hieu qua. 

Su giong nhau: Mo hinh OSI va TCP/IP co mot so diem chung nhu sau: deu co phan lop, deu co lop network va transport, cung su dung ky thuat chuyen packet.

Su khac nhau:
- Phuong phap tiep can: 
	- OSI: tiep can theo chieu doc
	- TCP/IP tiep can theo chieu ngang
- Thiet ke: 
	- OSI: Phat trien mo hinh truoc sau do se phat trien giao thuc
	- TCP/IP: Cac giao thuc duoc thiet ke truoc sau do phat trien mo hinh sau
- Truyen thong: 
	- OSI: Lop Transport chi xac dinh huong ket noi	
	- TCP/IP: Ho tro ca ket noi TCP va UDP

- Do tin cay va pho bien:
	- OSI: Nhieu nguoi cho rang day chi la mo hinh cu, chi de tham khao, so nguoi su dung con han che hon so voi TCP/IP.
	- TCP/IP: Duoc chuan hoa, nhieu nguoi tin cay va su dung pho bien tren toan cau.
2. TCP 3-way Handshake

client             Server
 SYN      --------> 		(client yeu cau ket noi)
          <--------  SYN-ACK 	(Dong y, gui lai so Sequence Number cua Server)
 ACK      -------->  		(Client xac nhan, ket noi ESTABLISHED)

Explain:
flag SYN: yeu cau ket noi
flag ACK: Xac nhan 
flag FIN: dong ket noi binh thuong
flag RST: reset ket noi ngay lap tuc

3. Khi nao chon UDP thay TCP? Vi du thuc te.
- UDP la giao thuc lop van chuyen cua giao thuc Internet (IP) cung cap kha do phu hop coi cac ung dung thoi gian thuc va nhay cam ve thoi gian nhu truyen phat video, DNS va VoIP. 
- UDP duoc gui di thay cho TCP khi khong can ben server xac thuc 3 buoc, can phan hoi nhanh, do tre thap, streaming lien tuc, co the chap nhan viec mat mot vai goi tin (khong can truyn lai)
vi du: Game online thoi gian thuc, goij Video/VoIP, livestream, truy van DNS. 

4. CIDR: 
/24 - 256 IP
/16 - 65536 IP
/22 - 1024 IP

5. Tai sao co private IP range?
private Ip dung trong mang noi bo de tiet kiem IPv4 cong cong.

6. NAT la gi? Phan biet SNAT vs DNAT.
NAT la Network Address Translation-tuc la dich dia chi mang. NAT cho phep chuyen doi dia chi IP rieng thanh dia chi IP cong cong va nguoc lai.
Chuc nang chinh:
- Tiet kiem IP cong cong: Giam thieu tinh trang khan hien IPv4 bang cach cho phep nhieu thiet bi chia se mot dia chi IP cong cong.
- Che dau IP ben trong LAN: an dia chi mang noi bo khoi mang ben ngoai.
- Dich dia chi IP: Chuyen tu Private Ip sang Public IP truoc khi ra goi Internet.
- Quan ly truy cap: Loc goi tin, cho phep/cam truy cap den port cu the.

SNAT va DNAT la 2 trong 3 loai NAT pho bien trong he thong mang. Trong do:
- SNAT-Static NAT-NAT tinh:
	- anh xa 1-1(mot private IP -> mot public IP co dinh)
	- co che gan cung/private IP luon map voi public IP tuong ung
	- Ung dung: NAT server(web server, email server can truy cap Internet tu ben ngoai) 
	- Uu diem: Che giau IP nguon, giam nguy co tan cong mang
	- Nhuoc diem: Ton kem-can so luong public Ip tuong ung voi so thiet bi
- DNAT-Dynamic NAT-NAT dong: 
	- anh xa 1-n(mot private Ip -> public IP tu pool/group)
	- co che: tao bang anh xa dong tu private IP sang public IP trong pool
	- Ung dung: Khi nhieu user trong mang can truy cap ra Internet
	- Uu diem: Quan ly linh dong, khong can gan cung
	- Nhuoc diem: Van ton kem vi can nhieu public IP de tao pool
7. Su khac nhau giua Forward Proxy va Reverse Proxy

Proxies dong vai tro quan trong trong quan ly luong du lieu may khach va may chu. 

- Forward Proxy : hoat dong thay mat client de nang cao quyen rieng tu va kiem soat quyen truy cap
- Reverse Proxy: hoat dong thay mat server de toi uu hoa hieu suat va bao mat.

- Forward Proxy: duoc trien khai truoc client(trong mang noi bo), muc dich an danh client, kiem soat truy cap; Bao ve client khi ra Internet, configure proxy do client viet, cache o client side, ung dung trong mang doanh nghiep, hoc duong
- Reverse Proxy: duoc trien khai truoc server(truoc backend server), muc dich bao ve server, load balancing, toi uu hieu suat; bao mat bao ve backend server khoi tan cong, client khong biet co proxy, ho tro phan phoi tai, cache server responses de giam tai, he thong web voi nhieu backend server.

