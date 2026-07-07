# S3 Presigned URL

Generate a presigned URL with 5-minute TTL:

```bash
python3 presign.py \
  --bucket <bucket> \
  --key private.pdf \
  --region ap-southeast-1 \
  --expires-in 300 EOF
