# Workflow Comparison

| Tiêu chí             | Trunk-based Development            | GitFlow                              | GitHub Flow                        |
| -------------------- | ---------------------------------- | ------------------------------------ | ---------------------------------- |
| Số long-lived branch | 1 (main)                           | 2 hoặc nhiều hơn (main, develop)     | 1 (main)                           |
| Phù hợp scenario nào | CI/CD, DevOps, triển khai liên tục | Dự án lớn có nhiều phiên bản release | Web app, startup, SaaS             |
| Release cadence      | Rất thường xuyên                   | Theo chu kỳ release                  | Thường xuyên                       |
| Khó khăn khi áp dụng | Cần kiểm thử tự động tốt           | Quy trình phức tạp, nhiều branch     | Cần review code kỹ trước khi merge |

## Trunk-based Development

Trunk-based Development sử dụng một nhánh chính duy nhất là `main`. Các lập trình viên tạo branch ngắn hạn và merge lại thường xuyên. Workflow này phù hợp với môi trường DevOps và CI/CD vì giúp giảm xung đột mã nguồn và tăng tốc độ triển khai.

### Ưu điểm

* Đơn giản, dễ quản lý.
* Hỗ trợ Continuous Integration tốt.
* Giảm merge conflict.

### Nhược điểm

* Yêu cầu hệ thống test tự động đáng tin cậy.
* Các thay đổi lớn cần được chia nhỏ.

---

## GitFlow

GitFlow sử dụng nhiều branch như `main`, `develop`, `feature`, `release` và `hotfix`. Đây là workflow phổ biến trong các dự án có quy trình phát hành chặt chẽ.

### Ưu điểm

* Quản lý release rõ ràng.
* Dễ bảo trì nhiều phiên bản sản phẩm.
* Phù hợp với dự án lớn.

### Nhược điểm

* Nhiều branch nên khá phức tạp.
* Dễ phát sinh conflict khi merge.
* Không tối ưu cho Continuous Deployment.

---

## GitHub Flow

GitHub Flow là workflow đơn giản dựa trên branch ngắn hạn và Pull Request. Mọi thay đổi được thực hiện trên branch riêng, sau đó review và merge vào `main`.

### Ưu điểm

* Dễ học và dễ sử dụng.
* Tích hợp tốt với GitHub Pull Request.
* Phù hợp với nhóm nhỏ và vừa.

### Nhược điểm

* Không hỗ trợ quản lý nhiều phiên bản release tốt như GitFlow.
* Cần quy trình review code nghiêm túc.

---

## Kết luận

Trong môi trường DevOps hiện đại, Trunk-based Development và GitHub Flow thường được ưu tiên vì hỗ trợ CI/CD và triển khai nhanh. GitFlow phù hợp hơn với các dự án lớn có quy trình phát hành theo từng phiên bản và yêu cầu quản lý release chặt chẽ.
