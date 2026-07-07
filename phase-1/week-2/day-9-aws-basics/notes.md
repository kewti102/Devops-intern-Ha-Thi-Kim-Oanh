# Day 9 — AWS Essentials Notes

## Part A — IAM

### 1. Phân biệt user, group, role, policy

**IAM user** là identity đại diện cho một người dùng hoặc một workload cần truy cập AWS bằng credentials riêng. User có thể có password để login AWS Console hoặc access key để dùng AWS CLI/API.

**IAM group** là tập hợp nhiều IAM user. Group giúp gán quyền cho nhiều user cùng lúc. Ví dụ group `s3-readonly` có policy chỉ đọc S3, user nào được add vào group này sẽ có quyền tương ứng.

**IAM role** là identity không gắn cố định với một người dùng cụ thể. Role được assume bởi user, service hoặc workload để nhận temporary credentials. Ví dụ EC2 assume role để truy cập S3 mà không cần lưu access key trên máy.

**IAM policy** là tài liệu JSON định nghĩa quyền được Allow hoặc Deny trên action/resource nào, có thể kèm condition.

### 2. Trust policy vs identity policy vs resource policy

**Trust policy** gắn với IAM role, quy định ai hoặc service nào được phép assume role đó. Ví dụ cho phép EC2 service assume role.

**Identity policy** gắn với IAM user, group hoặc role. Nó quy định identity đó được làm gì trên AWS resource nào. Ví dụ user được `s3:GetObject`.

**Resource policy** gắn trực tiếp trên resource. Ví dụ S3 bucket policy cho phép public đọc object hoặc cho account khác truy cập bucket.

### 3. Tại sao IAM role tốt hơn IAM user key cho EC2/CI/CD?

IAM role tốt hơn vì role dùng temporary credentials, tự rotate và có thời hạn. Khi dùng role cho EC2 hoặc CI/CD, mình không cần hard-code access key/secret key trong source code, file config hoặc máy chủ.

IAM user access key là long-term credential. Nếu bị leak, key có thể bị lạm dụng cho đến khi bị disable/delete. Vì vậy role an toàn hơn, dễ quản lý hơn và phù hợp với best practice.

### 4. Đọc policy JSON và giải thích từng trường

Policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["s3:GetObject"],
    "Resource": "arn:aws:s3:::my-bucket/*",
    "Condition": { "IpAddress": { "aws:SourceIp": "203.0.113.0/24" } }
  }]
}
             
## Part E — VPC Topology

### 1. ASCII Diagram

```text
                         Internet
                            |
                            v
                    +---------------+
                    |      IGW      |
                    +---------------+
                            |
                            v
          +-------------------------------------+
          |          VPC 10.0.0.0/16            |
          |                                     |
          |  +-------------+   +-------------+  |
          |  | Public RT   |   | Private RT  |  |
          |  | 0.0.0.0/0   |   | 0.0.0.0/0   |  |
          |  | -> IGW      |   | -> NAT GW   |  |
          |  +-------------+   +-------------+  |
          |                                     |
          |  AZ A                               |
          |  +-----------------------------+    |
          |  | Public Subnet A             |    |
          |  | 10.0.1.0/24                 |    |
          |  | ALB node                    |    |
          |  | NAT Gateway A               |    |
          |  +-----------------------------+    |
          |              |                      |
          |              v                      |
          |  +-----------------------------+    |
          |  | Private Subnet A            |    |
          |  | 10.0.11.0/24                |    |
          |  | EC2 Backend 1               |    |
          |  +-----------------------------+    |
          |                                     |
          |  AZ B                               |
          |  +-----------------------------+    |
          |  | Public Subnet B             |    |
          |  | 10.0.2.0/24                 |    |
          |  | ALB node                    |    |
          |  | NAT Gateway B               |    |
          |  +-----------------------------+    |
          |              |                      |
          |              v                      |
          |  +-----------------------------+    |
          |  | Private Subnet B            |    |
          |  | 10.0.12.0/24                |    |
          |  | EC2 Backend 2               |    |
          |  +-----------------------------+    |
          |                                     |
          +-------------------------------------+

Traffic inbound:
User -> Internet -> IGW -> ALB in public subnets -> EC2 backends in private subnets

Traffic outbound from backend:
EC2 private subnet -> Private Route Table -> NAT Gateway -> IGW -> Internet                    
