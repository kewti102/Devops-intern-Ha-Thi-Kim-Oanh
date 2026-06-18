SIGTERM - Khi nguoi dung lenh kill/killall mac dinh gui SIGTERM
SIGINT - Khi nguoi dung nhan ctrl+C trong terminal
SIGKILL - kill -9 PID
SIGHUP - terminal ngat (user/network disconnect)

nohup - giup process khong bi dung khi terminal dong hoac session mat ket noi
disown - remove job khoi job table 
setsid - chay process trong mot session moi

khi nao dung pkill -f?
khi can kill process dua tren toan bo command line, khong chi ten process

Giai thich cot STAT:
R: Running or runable, process o trang thai running or ready
S: Sleeping, process dang ngu va co the bi danh thuc
D: Uninterruptible sleep, thuong dang cho I/O, kho kill ngay ca bang signal thong thuong
Z: Zombie process, process da ket thuc nhung parent chua goi wait() de thu don
T: Stopped, process bi dung, vi du do Ctrl+Z hoac signal SIGSTOP

Zombie process la child process da ket thuc, nhung parent process chua goi wait() de doc exit status. Cach xu ly la xu ly parent process de parent goi wait(), hoac restart/kill parent neu can.

