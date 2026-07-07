# Task: Day 9 — AWS Essentials

- **Intern**: `Hà Thị Kim Oanh`
- **Phase / Week / Day**: `Phase 1 / Week 2 / Day 9`
- **Branch**: `phase-1/week-2/day-9-aws-basics`
- **Submitted at**: `2026-07-07 <HH:MM> +07`
- **Time spent**: `6h`
## 1. Mục tiêu

Task này nhằm thực hành các kiến thức AWS cơ bản gồm IAM, S3, presigned URL và VPC topology.

Nội dung chính:

- Hiểu IAM user, group, role, policy, trust policy, identity policy và resource policy.
- Thực hành tạo IAM user read-only với S3 và kiểm tra quyền bằng AWS CLI profile riêng.
- Tạo S3 static website public bằng bucket policy.
- Tạo private S3 bucket và generate presigned URL TTL 5 phút bằng AWS CLI và Python boto3.
- Vẽ và giải thích mô hình VPC gồm public subnet, private subnet, IGW, NAT Gateway, ALB và EC2 backend.

## 2. Cách chạy

### 2.1. Yêu cầu môi trường

Máy Linux đã cài AWS CLI, Python 3 và Git:

```bash
aws --version
python3 --version
git --version
```

AWS CLI cần được cấu hình bằng IAM user, không dùng root account:

```bash
aws configure
aws sts get-caller-identity
```

Region sử dụng trong bài:

```bash
export AWS_REGION="ap-southeast-1"
```

### 2.2. IAM lab

Tạo IAM group `s3-readonly`, gắn managed policy `AmazonS3ReadOnlyAccess`, tạo user `test-ro`, add user vào group và cấu hình profile:

```bash
aws iam create-group --group-name s3-readonly

aws iam attach-group-policy \
  --group-name s3-readonly \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

aws iam create-user --user-name test-ro

aws iam add-user-to-group \
  --user-name test-ro \
  --group-name s3-readonly

aws iam create-access-key --user-name test-ro
aws configure --profile test-ro
```

Test quyền read-only:

```bash
aws --profile test-ro s3 ls
aws --profile test-ro s3 cp iam-lab/test.txt s3://<bucket>/
```

Kết quả mong đợi:

- `aws --profile test-ro s3 ls` chạy được.
- `aws --profile test-ro s3 cp ...` bị lỗi `AccessDenied` vì user chỉ có quyền read-only.

Sau khi test xong, disable/delete access key:

```bash
aws iam update-access-key \
  --user-name test-ro \
  --access-key-id <access-key-id> \
  --status Inactive

aws iam delete-access-key \
  --user-name test-ro \
  --access-key-id <access-key-id>
```

> Lưu ý: Access key và secret key không được commit lên Git. Transcript log đã được redact nếu có thông tin nhạy cảm.

### 2.3. S3 static website

Tạo bucket static website:

```bash
aws s3api create-bucket \
  --bucket <name>-static-<random> \
  --region ap-southeast-1 \
  --create-bucket-configuration LocationConstraint=ap-southeast-1
```

Tắt Block Public Access cho bucket lab:

```bash
aws s3api put-public-access-block \
  --bucket <bucket> \
  --public-access-block-configuration \
  BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
```

Bật static website hosting:

```bash
aws s3 website s3://<bucket>/ \
  --index-document index.html \
  --error-document error.html
```

Upload file:

```bash
aws s3 cp s3-static/index.html s3://<bucket>/index.html --content-type "text/html"
aws s3 cp s3-static/error.html s3://<bucket>/error.html --content-type "text/html"
```

Apply bucket policy public `GetObject`:

```bash
aws s3api put-bucket-policy \
  --bucket <bucket> \
  --policy file://s3-static/bucket-policy.json
```

Truy cập website endpoint:

```bash
curl http://<bucket>.s3-website-ap-southeast-1.amazonaws.com
```

Kết quả mong đợi: thấy nội dung trang trong `index.html`.

### 2.4. S3 presigned URL

Tạo private bucket, bật Block Public Access và upload file private:

```bash
aws s3api create-bucket \
  --bucket private-<name>-<random> \
  --region ap-southeast-1 \
  --create-bucket-configuration LocationConstraint=ap-southeast-1

aws s3api put-public-access-block \
  --bucket <private-bucket> \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

aws s3 cp s3-presign/private.pdf s3://<private-bucket>/private.pdf
```

Generate presigned URL bằng AWS CLI:

```bash
aws s3 presign s3://<private-bucket>/private.pdf \
  --expires-in 300 \
  --region ap-southeast-1
```

Test tải file:

```bash
curl -L "<presigned-url>"
```

Sau 5 phút, URL phải hết hạn.

Chạy script Python:

```bash
cd s3-presign

python3 -m venv .venv
source .venv/bin/activate
pip install boto3

python3 presign.py \
  --bucket <private-bucket> \
  --key private.pdf \
  --region ap-southeast-1 \
  --expires-in 300
```

### 2.5. Cleanup

Sau khi hoàn thành lab, dọn toàn bộ resource:

```bash
aws s3 rm s3://<static-bucket> --recursive
aws s3api delete-bucket --bucket <static-bucket> --region ap-southeast-1

aws s3 rm s3://<private-bucket> --recursive
aws s3api delete-bucket --bucket <private-bucket> --region ap-southeast-1

aws s3 rm s3://<iam-test-bucket> --recursive
aws s3api delete-bucket --bucket <iam-test-bucket> --region ap-southeast-1
```

Xoá IAM lab user/group:

```bash
aws iam remove-user-from-group \
  --user-name test-ro \
  --group-name s3-readonly

aws iam detach-group-policy \
  --group-name s3-readonly \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

aws iam delete-user --user-name test-ro
aws iam delete-group --group-name s3-readonly
```

Kiểm tra không còn bucket Day 9:

```bash
aws s3api list-buckets --query "Buckets[].Name" --output text | tr '\t' '\n' | grep -E "static|private|iam-test" || echo "No Day 9 buckets found"
```

## 3. Kết quả

Kết quả bài làm được lưu trong:

- `notes.md`
- `iam-lab/transcript.log`
- `s3-static/index.html`
- `s3-static/error.html`
- `s3-static/bucket-policy.json`
- `s3-presign/presign.py`
- `s3-presign/README.md`
- `screenshots/`

Screenshot/log output kèm trong `./screenshots/`, gồm các phần IAM, static site, presigned URL, Python script, cleanup và cost check.

## 4. Khó khăn & cách giải quyết

- **Vấn đề 1: Transcript log có thể chứa AWS access key/secret key.**  
  Cách fix: redact thông tin nhạy cảm trong `iam-lab/transcript.log`, xoá file backup `.bak.local`, không commit access key, không commit `.venv/`, `*.tfstate`, `.env`, `*.pem`, `*.key`.

- **Vấn đề 2: IAM user read-only vẫn upload được hoặc test không đúng.**  
  Cách fix: kiểm tra user `test-ro` chỉ nằm trong group `s3-readonly`, không gắn thêm policy ghi S3 trực tiếp vào user. Expected result là upload bị `AccessDenied`.

- **Vấn đề 3: Static site bị `AccessDenied`.**  
  Cách fix: kiểm tra bucket policy public `s3:GetObject`, static website hosting, object đã upload đúng tên `index.html`, và Block Public Access đã được tắt cho bucket lab.

- **Vấn đề 4: Presigned URL không tải được file.**  
  Cách fix: kiểm tra bucket name, object key, region, credentials dùng để generate URL và TTL `--expires-in 300`.

- **Vấn đề 5: S3 bucket không xoá được.**  
  Cách fix: empty bucket trước bằng `aws s3 rm s3://<bucket> --recursive`, sau đó mới `delete-bucket`.

## 5. Reference

## 6. Self-check

- [ ] Code chạy được trên máy sạch.
- [ ] README có hướng dẫn run lại.
- [ ] Không hard-code secret.
- [ ] Không commit AWS access key / secret key.
- [ ] Không commit `.venv/`, `.env`, `*.tfstate`, `*.pem`, `*.key`, `*.bak.local`.
- [ ] IAM user `test-ro` upload S3 bị `AccessDenied` đúng yêu cầu.
- [ ] Static site truy cập được public.
- [ ] Presigned URL hoạt động và expire đúng.
- [ ] Python script `presign.py` chạy được.
- [ ] Đã empty + delete bucket sau lab.
- [ ] Đã disable/delete IAM access key sau lab.
- [ ] Đã delete IAM user/group lab.
- [ ] Đã check cost sau lab.
- [ ] Commit message theo Conventional Commits.
- [ ] Đã review lại code 1 lượt.
