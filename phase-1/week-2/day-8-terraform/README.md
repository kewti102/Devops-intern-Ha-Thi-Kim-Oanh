# Task: Day 8 — Terraform Basics

- **Intern**: `Hà Thị Kim Oanh`
- **Phase / Week / Day**: `Phase 1 / Week 2 / Day 8`
- **Branch**: `phase-1/week-2/day-8-terraform`
- **Submitted at**: `2026-07-06 <HH:MM> +07`
- **Time spent**: `6h

## 1. Mục tiêu

Task này nhằm làm quen với Terraform và mô hình Infrastructure as Code theo hướng declarative.  
Nội dung chính gồm: provider, resource, variable, output, state, data source, remote backend và cách provision hạ tầng cơ bản trên AWS.

Kết quả cần đạt:

- Hoàn thành lab local với provider `random` và `local`.
- Provision được hạ tầng AWS gồm VPC, public subnet, Internet Gateway, route table, security group, EC2, Elastic IP và nginx.
- Kiểm tra được web server bằng `curl http://<public_ip>`.
- Destroy sạch resource sau khi hoàn thành để tránh phát sinh chi phí.

## 2. Cách chạy

### 2.1. Yêu cầu môi trường

Máy Linux đã cài:

```bash
terraform version
aws --version
git --version
curl --version
```

AWS CLI đã được cấu hình:

```bash
aws configure
aws sts get-caller-identity
```

### 2.2. Clone repo và vào đúng branch

```bash
git clone <repo-url>
cd day-8-terraform
git checkout phase-1/week-2/day-8-terraform
```

### 2.3. Chạy Mini lab 1 — Local-only

```bash
cd 1-local

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve

terraform output
ls -la out/
cat out/*.txt
```

Sửa trong `main.tf`:

```hcl
resource "random_pet" "name" {
  length = 3
}
```

Sau đó chạy lại:

```bash
terraform plan
terraform apply -auto-approve
terraform output
ls -la out/
cat out/*.txt
```

Dọn resource local:

```bash
terraform destroy -auto-approve
```

### 2.4. Chạy Mini lab 2 — AWS VPC + EC2

Vào thư mục AWS lab:

```bash
cd ../2-aws
```

Tạo file biến thật từ file mẫu:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Cập nhật `terraform.tfvars`:

```hcl
region = "ap-southeast-1"
owner  = "ha-thi-kim-oanh"
my_ip  = "<your-public-ip>/32"
key_name = ""
```

Có thể lấy public IP bằng:

```bash
curl -s https://checkip.amazonaws.com
```

Chạy Terraform:

```bash
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Lấy public IP:

```bash
terraform output
terraform output -raw public_ip
```

Kiểm tra nginx:

```bash
IP="$(terraform output -raw public_ip)"
curl "http://$IP"
```

Kết quả mong đợi:

```text
hello from <hostname>
```

Dọn sạch resource AWS:

```bash
terraform destroy -auto-approve
```

### 2.5. Remote backend bonus

Nếu có làm phần remote backend:

```bash
cd ../0-backend

terraform init
terraform fmt
terraform validate
terraform apply -auto-approve
terraform output
```

Sau đó cấu hình backend S3 trong `2-aws/backend.tf` và migrate state:

```bash
cd ../2-aws
terraform init -migrate-state
terraform state list
```

Sau khi kiểm tra xong, destroy resource:

```bash
terraform destroy -auto-approve
```

## 3. Kết quả

Kết quả được lưu trong các file log và thư mục screenshot:

- `1-local-transcript.log`
- `2-aws-transcript.log`
- `remote-migrate-transcript.log` nếu có làm remote backend
- `screenshots/`
- Đã chạy `terraform destroy` sạch sẽ sau khi hoàn thành.

## 4. Khó khăn & cách giải quyết

- **Vấn đề 1: File transcript bị lỗi hiển thị hoặc bị ký tự lạ.**  
  Cách xử lý: dùng `less -R` để đọc log hoặc capture lại bằng `tee` thay vì mở bằng Text Editor.

- **Vấn đề 2: Sau khi `terraform destroy`, `terraform state list` không còn resource để migrate.**  
  Cách xử lý: nếu cần demo migrate state, phải apply bằng local state trước, sau đó mới thêm backend S3 và chạy `terraform init -migrate-state`.

- **Vấn đề 3: Không curl được EC2 public IP.**  
  Cách xử lý: kiểm tra security group đã mở port 80 từ `0.0.0.0/0`, EC2 nằm trong public subnet, route table có route ra Internet Gateway và user-data đã cài nginx.

- **Vấn đề 4: AWS có thể phát sinh chi phí nếu quên dọn resource.**  
  Cách xử lý: bật billing alert $1 và luôn chạy `terraform destroy -auto-approve` sau khi hoàn thành lab.

## 5. Reference

## 6. Self-check

- [ ] Code chạy được trên máy sạch.
- [ ] README có hướng dẫn run lại.
- [ ] Không hard-code secret.
- [ ] Không commit `*.tfstate`, `*.tfstate.*`, `*.tfvars`, `.terraform/`.
- [ ] Có giữ `terraform.tfvars.example` để mentor biết cần cấu hình biến gì.
- [ ] Đã chạy `terraform fmt`.
- [ ] Đã chạy `terraform validate`.
- [ ] Đã chạy `terraform plan`.
- [ ] Đã chạy `terraform apply`.
- [ ] Đã kiểm tra `curl http://<public_ip>`.
- [ ] Đã chạy `terraform destroy` sạch sẽ.
- [ ] Commit message theo Conventional Commits.
- [ ] Đã review lại code 1 lượt.
