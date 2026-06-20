# Day 3 — Git Advanced

* Task: Day 3 — Git Advanced
* Intern: Hà Thị Kim Oanh
* Phase / Week / Day: Phase 1 / Week 1 / Day 3
* Branch: phase-1/week-1/day-3-git
* Submitted at: 2026-06-20
* Time spent: 5h

## 1. Mục tiêu

Thực hành các kỹ năng Git nâng cao gồm rebase, cherry-pick, conflict resolution, reflog, bisect, pre-commit hook và so sánh các workflow Git phổ biến.

## 2. Git Lab Repository

GitHub Repository:
https://github.com/kewti102/git-lab

git clone https://github.com/kewti102/git-lab
cd git-lab
### Kiem tra cac branch
git branch -a

### Kiểm tra history
git log --oneline --graph --all
### Kiểm tra bisect log
cat bisect.log
### Kiểm tra pre-commit
pre-commit run --all-files


## 3. Kết quả
- `3commit.png`: Tạo 3 commit trên branch feature-a.
- `rebasemergeconfict.png`: Rebase feature-b lên feature-a và xử lý conflict thủ công.
- `hotfix.png`: Tạo hotfix và thực hiện cherry-pick sang các branch yêu cầu.
- `git_reflog_1.png`, `git_reflog_2.png`: Sử dụng git reflog để tìm và khôi phục commit đã mất.
- `bisect.log.png`: Sử dụng git bisect để xác định commit gây lỗi.
- `PartD.png`: Cấu hình và cài đặt pre-commit hooks.
- `xoacommit.png`: Thực hiện reset làm mất commit trong bài thực hành reflog.
- `partC.png`: Quá trình xác định commit lỗi trong bài git bisect.

## 4. Khó khăn & cách giải quyết
Một số lệnh Git thực hiện sai thứ tự hoặc sai cú pháp → đọc lại log và thực hiện đúng quy trình.
Gặp conflict khi rebase và cherry-pick → resolve thủ công và tiếp tục bằng git rebase --continue.
## 5. Reference
Google
Chatgpt
## 6. Self-check

✅ Rebase và resolve conflict thành công.

✅ Cherry-pick hotfix sang branch yêu cầu.

✅ Khôi phục commit bằng reflog.

✅ git bisect tìm đúng commit lỗi.

✅ Pre-commit hook chặn commit lỗi.

✅ So sánh workflow bằng nội dung tự viết.
