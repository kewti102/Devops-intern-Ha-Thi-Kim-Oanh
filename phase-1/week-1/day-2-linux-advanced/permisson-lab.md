Part C - Permission Lab

Muc tieu:
Tao folder /tmp/shared-lab cung voi cac quyen nang cao cua Linux:
- Nhom devops co the doc va ghi
- Tao file moi ke thua nhom devops
- file secret.txt chi co the doc boi owner
- Cap quyen truy cap read-only bang ACL

Buoc 1: Tao nhom devops

sudo groupadd devops 2>/dev/null || true
sudo usermod -aG devops "$USER" 
newgrp devops 
id 
Ket qua mong doi: Current user thuoc vao group devops

Buoc 2: Tao shared Directory

sudo mkdir -p /tmp/shared-lab
sudo chgrp devops /tmp/shared-lab 
sudo chmod 2770 /tmp/shared-lab 
sudo setfacl -d -m g:devops:rwx /tmp/shared-lab 
sudo setfacl -m g:devops:rwx /tmp/shared-lab

Xac minh:

ls -ld /tmp/shared-lab
getfacl /tmp/shared-lab

Buoc 3: Xac minh group inheritance

touch /tmp/shared-lab/group-test.txt 
ls -l /tmp/shared-lab/group-test.txt

Results: group-test.txt co group devops.

Buoc 4: Tao owner-only secret file

echo "top secret" > /tmp/shared-lab/secret.txt
chmod 400 /tmp/shared-lab/secret.txt
ls -l /tmp/shared-lab/secret.txt

result: -r-------- 1 <user> devops ... secret.txt

Buoc 5: Them read-only ACl for another user

sudo useradd -m reviewer 2>/dev/null || true
echo "read only file for reviewer" > /tmp/shared-lab/public.txt
chmod 660 /tmp/shared-lab/public.txt
sudo setfacl -m u:reviewer:rx /tmp/shared-lab
sudo setfacl -m u:reviewer:r-- /tmp/shared-lab/public.txt

Verify ACL:

getfacl /tmp/shared-lab
getfacl /tmp/shared-lab/public.txt

Read test:

sudo -u reviewer cat /tmp/shared-lab/public.txt

Write test:

sudo -u reviewer bash -c 'echo "try write" >> /tmp/shared-lab/public.txt'

result: Write operation fails with Permission denied

Final verification commands
ls -ld /tmp/shared-lab
ls -l /tmp/shared-lab
getfacl /tmp/shared-lab
getfacl /tmp/shared-lab/public.txt
getfacl /tmp/shared-lab/secret.txt

