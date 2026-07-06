# Day 8 — Terraform Basics Notes

## 1. State file là gì? Vì sao không được commit lên Git?

State file (`terraform.tfstate`) là file Terraform dùng để map giữa code `.tf` và resource thật trên provider. Ví dụ: resource `aws_instance.web` trong code đang tương ứng với instance ID nào trên AWS.

Không commit state lên Git vì:
- Có thể chứa thông tin nhạy cảm như IP, ARN, attributes, đôi khi cả secret tùy resource/provider.
- Dễ bị conflict khi nhiều người cùng apply.
- Nếu state bị sửa/xóa sai, Terraform có thể hiểu sai hạ tầng thật và tạo/xóa nhầm resource.
- Nên dùng remote backend có locking để chia sẻ state an toàn.

## 2. So sánh terraform plan vs terraform apply vs terraform refresh

- `terraform plan`: đọc config + state + trạng thái thực tế, sau đó hiển thị Terraform sẽ tạo/sửa/xóa gì. Chưa thay đổi hạ tầng.
- `terraform apply`: thực thi các thay đổi trong plan để đưa hạ tầng thật về desired state.
- `terraform refresh`: cập nhật state theo trạng thái thật nhưng không sửa hạ tầng. Lệnh standalone này đã deprecated; nên dùng `terraform plan -refresh-only` hoặc `terraform apply -refresh-only`.

## 3. Tại sao nên dùng remote backend S3 + DynamoDB lock?

Remote backend giúp state được lưu tập trung thay vì nằm local từng máy. Khi làm team/CI, mọi người dùng chung một nguồn state. Locking giúp tránh 2 người cùng `apply` làm hỏng state. S3 lưu state bền hơn local, có thể bật versioning/encryption. DynamoDB lock là cách cũ/phổ biến để khóa state, nhưng Terraform mới có S3 native lock bằng `use_lockfile = true`.

## 4. So sánh module local vs registry

- Local module: module nằm trong repo hoặc đường dẫn local như `./modules/vpc`. Dễ tùy biến, phù hợp code nội bộ.
- Registry module: module lấy từ Terraform Registry, ví dụ module VPC có sẵn. Nhanh, có version, nhưng cần review kỹ input/output/source và pin version.

## 5. count vs for_each — khi nào dùng cái nào?

- `count`: dùng khi các resource giống nhau và chỉ cần số lượng, truy cập bằng index `[0]`, `[1]`. Phù hợp tạo 2 subnet đơn giản.
- `for_each`: dùng khi mỗi resource có key rõ ràng, ví dụ map `{ public-a = ..., public-b = ... }`. Ổn định hơn khi thêm/xóa item vì key không đổi như index.
- Nếu resource có danh tính riêng, ưu tiên `for_each`. Nếu chỉ nhân bản theo số lượng, dùng `count`.

## 6. Drift là gì, cách phát hiện & xử lý?

Drift là khi hạ tầng thật bị thay đổi ngoài Terraform, làm khác với code/state. Ví dụ sửa security group trực tiếp trên AWS Console.

Phát hiện:
- Chạy `terraform plan` để Terraform refresh và báo khác biệt.
- Có thể dùng `terraform plan -refresh-only` để xem khác biệt giữa state và thực tế.

Xử lý:
- Nếu thay đổi ngoài console là đúng: cập nhật code rồi apply.
- Nếu thay đổi ngoài console là sai: chạy `terraform apply` để đưa hạ tầng về lại desired state.
- Tránh sửa tay trên console khi resource đã do Terraform quản lý.
