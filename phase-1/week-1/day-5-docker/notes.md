
## 1. Docker Image được tạo từ nhiều layer (lớp) chỉ đọc (read-only). Mỗi lệnh trong Dockerfile như `FROM`, `RUN`, `COPY`, `ADD` sẽ tạo ra một layer mới.
Các layer sẽ lần lượt tương ứng với:

Base image (node:20-alpine)
Tạo thư mục làm việc (WORKDIR)
Copy file package.json
Cài đặt dependency (npm install)
Copy source code
Cấu hình lệnh chạy container (CMD)

## 2. Su khac nhau giua copy va add
Ca copy va add deu dung de dua file tu host vao Docker imagine.

### Copy

- Chi sao chep file hoac thu muc tu host vao imagine
- chuc nang don gian, de hieu
- duoc khuyen nghi su dung trong hau het truong hop

### add

ngoai chuc nang cua copy, add con co the:
- tu dong giai nen file nen cuc bo (.tar, .tar.gz, ...)
- tai file tu URL (khong khuyen khich su dung)

## 3. CMD vs ENTRYPOINT - khi nao dung cai nao?

### CMD 
CMD dung de chi dinh lenh mac dinh se chay khi container khoi dong

Dac diem:
- co the bi ghi de hoan toan khi chay `docker run`.
- thuong dung de cung cap tham so hoac lenh mac dinh

### ENTRYPOINT

entrypoint dung de chi dinh chuong trinh chinh cua container.

Dac diem:
- kho bi ghi de hon
- moi tham so truyen vao docker run se duoc noi them vao sau entrypoint
- thuong dung khi container hoat dong nhu mot executable

## 4. Tai sao nen co `.dockerignore`
File `.dockerignore` dung de loai tru cac file hoac thu muc khong can thiet khoi Docker build context.
Loi ich: chung giup build nhanh hon, giam dung luong imagine, tranh dua cac file nhay cam vao imagine, giam so lan Docker phai rebuild cac layer khi cac file khong lien quan thay doi

## 5. EXPOSE thuc su lam gi? co tu mo port khong?
`EXPOSE` dung de khai bao (document) rang container se lang nghe tren mot cong cu the.

EXPOSE khong tu mo port ra ngoai host.

## 6. Tai sao khong nen chay container as root?

Khong nen chay container bang tai khoan root vi ly do bao mat
Neu ung dung trong container bi khai thac lo hong, ke tan cong co quyen root ben trong container va gay anh huong den host hoac cac container khac.

Rui ro khi chay root:
- tang kha nang leo thang dac quyen (privilege escalation)
- co the truy cap hoac sua doi tai nguyen ngoai y muon
- vi pham nguyen tac "Least privilege" (cap quyen toi thieu can thiet).

