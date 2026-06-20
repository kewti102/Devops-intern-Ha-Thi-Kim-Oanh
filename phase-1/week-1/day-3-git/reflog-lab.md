# Reflog Lab

## Mục tiêu

Khôi phục một commit đã bị mất sau khi thực hiện lệnh:

```bash
git reset --hard HEAD~1
Các bước thực hiện
1. Tạo một commit mới
echo "lost commit demo" > lost.txt
git add lost.txt
git commit -m "feat: lost commit demo"
2. Xóa commit khỏi lịch sử hiện tại
git reset --hard HEAD~1
3. Tìm lại commit đã mất
git reflog

Kết quả hiển thị:

f0da7d8 HEAD@{1}: commit: feat: lost commit demo
4. Khôi phục commit

Tạo một branch mới từ SHA vừa tìm được:
git checkout -b recovered f0da7d8
